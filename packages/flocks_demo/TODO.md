# Pendências da demo

## A fonte que o runtime do Flutter busca no Google

Eram **duas** requisições a `fonts.gstatic.com` por carregamento frio, e nenhuma
delas era escolha da demo. Medidas em `https://flocks.live/demo/` em 2026-08-11,
nas duas telas:

| Fonte | Bytes | Quando | Estado |
| --- | --- | --- | --- |
| `roboto/v32/KFOmCnqEu92Fr1Me4GZLCzYlKw.woff2` | 63.464 | na carga de fontes, junto dos TTF locais, **antes do primeiro frame** | de pé |
| `notosanssymbols/v43/rP2up3q65FkA….woff2` | 69.116 | no **primeiro layout**, sem ninguém digitar nada | **consertada na raiz** |

A medição acima é de produção e continua descrevendo o build que está no ar: o
conserto da segunda linha só chega a `flocks.live` no próximo deploy.

**A Roboto sai mesmo sem a demo usá-la, e não é lazy.** O CanvasKit precisa de
uma fonte de fallback registrada para não estourar ao dispor texto com família
desconhecida, e escolheu a Roboto para casar com o Android. Em
`canvaskit/fonts.dart` do engine (SDK 3.44.0), `loadAssetFonts` percorre o
`FontManifest.json` e, se nenhuma família ali se chamar literalmente `Roboto`,
acrescenta `_downloadFont('Roboto', _robotoUrl, 'Roboto')` à lista que é
**aguardada** antes de seguir. Nosso manifesto declara `packages/flocks/Poppins`
e `packages/flocks/SpaceGrotesk`: a condição é sempre verdadeira. `_robotoUrl` é
`'${configuration.fontFallbackBaseUrl}roboto/v32/…woff2'`, e
`fontFallbackBaseUrl` cai no default `https://fonts.gstatic.com/s/` porque
ninguém o configura — `web/index.html` não tem bloco de config do loader.

**A Noto Sans Symbols era lazy, e o gatilho era nosso.** A fila de fallback do
engine baixa uma Noto por codepoint sem cobertura, e
`getMissingCodePoints(codePoints, fontFamilies)` confere a cobertura **só contra
as famílias daquele span**, não contra tudo o que está registrado. O bloco de
código do painel ("Take it with you") pede a pilha mono de
`app_content_style.dart` do `flocks` — `SF Mono`, `Menlo`, `Consolas`,
`Roboto Mono`, … —, e nenhuma delas está registrada no CanvasKit. Aí cada acento
do comentário em português do snippet ("já", "padrão", "só") vira codepoint
órfão.
Como acento latino é coberto por dezenas de Noto, dá empate, e o desempate do
engine prefere explicitamente a Noto Sans Symbols: **67,5 KB de uma fonte de
símbolos para desenhar "ã"**. O painel é chrome compartilhado, então as duas
telas pagavam.

**Como morreu:** o `flocks` passou a empacotar a IBM Plex Mono em
`assets/fonts/`, e `AppContentStyle.code` pede `packages/flocks/IBMPlexMono` sem
`fontFamilyFallback`. A família está registrada no CanvasKit, os acentos têm
cobertura, e a fila de fallback nunca abre. Medido nos dois builds servidos lado
a lado em `127.0.0.1`, com `performance.getEntriesByType('resource')` e
esperando o número de recursos estabilizar (a aba throttla o render, e medir
cedo demais confunde "ainda não pediu" com "não pede"):

| Build | Recursos | De terceiro |
| --- | --- | --- |
| `origin/main` (856baee) | 20 | Roboto 63.464 B + **Noto Sans Symbols 69.116 B** |
| com a mono empacotada | 21 | Roboto 63.464 B |

O recurso a mais é aritmética: entram os dois TTF da mono, sai a Noto. A
contrapartida, dita por inteiro: a demo passa a baixar **275.796 B** de mono da
**própria origem**, com o mesmo `max-age` de um ano dos outros TTF. Troca-se um
terceiro por bytes nossos, não se economiza banda.

Nada disso é alcançável pelos gates: acontece no bootstrap JavaScript e na fila
do engine, antes e fora de qualquer Dart nosso. A terceira irmã — o CanvasKit
vindo do `www.gstatic.com` — já foi corrigida com `--no-web-resources-cdn` no
CI, com gate estático em `test/architecture_test.dart`, e a medição confirma que
essa continua corrigida: zero requisições a `www.gstatic.com`.

**Por que a Roboto ainda não foi corrigida:** o caminho é `fontFallbackBaseUrl`
na configuração do loader, apontando para uma cópia das fontes de fallback
servida por nós. Isso significa vendorar a Roboto (Apache 2.0, redistribuível) e
reproduzir a estrutura de diretórios que o engine espera — sem contrato
documentado e sujeito a mudar entre versões do Flutter. E apontar a base para
nós obriga a decidir o que fazer com a fila de Noto inteira, que é grande e é
escolhida em tempo de execução. Note que empacotar a mono **não** ajuda aqui: a
condição que dispara o download da Roboto é o nome da família no
`FontManifest.json`, e `IBMPlexMono` não se chama `Roboto` mais do que `Poppins`
se chamava.

**O que isso não é:** não é o logo saindo da aba. São downloads de fonte, não
uploads, e o gate de rede continua provando que nenhum byte do logo vai a lugar
nenhum.

**Onde a frase falsa está escrita.** "Esta página não contacta host nenhum" não
está na tela nem no README — mas está em dois lugares, e é falsa nos dois:
`ci.yml`, no comentário do passo de build da demo (corrigido no PR que trouxe
esta medição), e o `reason` do gate do CDN em `test/architecture_test.dart`, que
segue dizendo que sem a flag "deixa de ser verdade que ela não contacta host
nenhum" — sem a flag ou com ela, a demo contacta.

**Como medir, para a próxima pessoa não errar como a anterior.** A auditoria de
2026-08-11 concluiu "39 requisições, todas em `flocks.live`, nenhuma para
`fonts.gstatic.com`" — e estava errada por método: a aba de rede usada lista só
requisições da origem da página, e as de terceiros não aparecem nela. O que vê
tudo é `performance.getEntriesByType('resource')` no console da própria página.
Os dois arquivos do gstatic vêm com `cache-control: public, max-age=31536000`,
então o byte sai na primeira visita e o cache responde nas seguintes; a primeira
visita de cada visitante é justamente a que a tese da demo descreve.

---

# Analytics — documentado, não implementado

O projeto PostHog ainda não existe, então **nada aqui está no código**. Este
arquivo fixa os nomes agora para que a instrumentação, quando chegar, não invente
um vocabulário novo — e para que a regra de privacidade abaixo entre junto com o
primeiro evento, e não depois do primeiro vazamento.

| Evento | Quando | Propriedades |
| --- | --- | --- |
| `demo opened` | a demo monta | os seis parâmetros do contrato de URL, como vieram |
| `demo brand changed` | a semente de cor muda | `seed` (hex) |
| `demo logo uploaded` | um logo é aceito | **só o fato.** Ver abaixo |
| `demo axis changed` | estilo, forma ou tipografia mudam | `axis`, `value` |
| `demo screen changed` | troca de tela | `screen` |
| `demo config exported` | o snippet Dart é copiado | os seis parâmetros |
| `demo link shared` | o link compartilhável é copiado | os seis parâmetros |

## A regra que não se negocia

`demo logo uploaded` registra **o fato, e nada mais**. Nunca a imagem, nunca os
bytes, nunca o nome do arquivo, nunca o tamanho, nunca o tipo MIME.

Isso não é excesso de zelo — é a mesma fronteira que
`test/no_network_test.dart` protege. A demo diz ao visitante, na tela, que o
logo dele não sai da aba. Um evento de analytics carregando `filename:
"logo-final-v3-aprovado.png"` desmente essa frase e sai por um caminho que o
gate de rede não vê, porque o cliente de analytics seria uma dependência
legítima com permissão para falar com o mundo.

Repare que o código já ajuda: o nome do arquivo **nunca chega ao estado da
demo** (`browser_web.dart` lê os bytes e descarta o resto, e o formato sai da
assinatura binária, não da extensão). Quem for instrumentar não vai encontrar o
nome do arquivo para registrar por engano — vai ter de ir buscá-lo de propósito.

## Ao implementar

Estender `test/architecture_test.dart` com a lista de dependências permitidas: um
cliente de analytics é, por definição, um caminho de rede, então o teste que hoje
exige ZERO requisições precisará distinguir o destino de telemetria de todo o
resto — e essa distinção é exatamente onde a fronteira do logo se perderia se
ninguém estivesse olhando.
