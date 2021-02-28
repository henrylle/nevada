# Resize Image em percent
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