# Resize Image em percent para Youtube
- Exemplo de chamada:
```
./resize_image_em_percent_para_youtube.sh stage/IMG_5445.JPG 50 true
```

| Parametros | Descricao |
| ------ | ----------- |
| param1 | Percentual do tamanho da imagem original. |
| param2 | Se deve redimensionar para o Youtube. Caso true, ele ira cropar a imagem para ficar perfeita como capa do Yotube, caso contrário ele apenas irá redimensionar a imagem com base no param1. |
| result    | será gerado uma imagem na mesma pasta do arquivo de origem para resize com o nome do arquivo original concatenado com a nova resolucao. |

*Obs: O CROP será em igual a escala para a parte superior e inferior da imagem*


# Resize Image em percent para Facebook

```
./resize_image_em_percent_para_facebook.sh stage/IMG_5445.JPG 50 instagram_feed
```
| Parametros | Descricao |
| ------ | ----------- |
| param1 | Path da imagem. |
| param2 | Percentual do tamanho da imagem original. |
| param3 | Para qual formato será redimensionado. Opções válidas. facebook_feed, facebook_stories, instagram_feed, instragram_stories. |
| param4 | Servirá para saber em quantos pixel deverá mover para a esquerda a posição do corte. Útil quando a imagem não está centralizada |
| result    | será gerado uma imagem na mesma pasta do arquivo de origem para resize com o nome do arquivo original concatenado com o formato e com a nova resolucao. |

# Resize Video

```
PREVIEW=true ./resize_video.sh stage/ads-01.mp4 facebook_feed
```
| Parametros | Descricao |
| ------ | ----------- |
| param1 | Path do vídeo. |
| param2 | Para qual formato será redimensionado. Opções válidas. facebook_feed, facebook_stories, instagram_feed, instragram_stories. |
| PREVIEW    | Variável de ambiente, que caso seja setado para true irá gerar uma imagem no segundo 10 com um quadrado vermelho bem no centro da imagem para ver se setá centralizado. Obs: Não é obrigatório |
| result    | Caso PREVIEW=false: Será gerado um vídeo na mesma pasta de origem com o prefixo final_. Caso PREVIEW=true  Será gerado uma imagem na mesma pasta de origem com o prefixo example_img_. |