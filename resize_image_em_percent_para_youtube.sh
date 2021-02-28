#Exemplo de chamada ./resize_image_em_percent_para_youtube.sh IMG_4071.JPG 50 true
#Obs: Se você escolher um arquivo de subpasta a imagem final tb será gerada na subpasta
#Resultado: Vai gerar um arquivo com 50% da resolução do arquivo IMG_4071.JPG e cropado para o Youtube
#OBS: Para NÃO CROPAR  a imagem passe o parâmetro como false. Caso contrário sempre será cropado para o Youtube.
#O CROP será em igual a escala para a parte superior e inferior da imagem
path=$1
resize_percent=$2
crop_youtube=$3
if [ -z $2 ]; then
  resize_percent=40
fi

if [ -z "$crop_youtube" ]; then
  crop_youtube="true"
fi
#ASPECT RATIO IDEAL PARA YOUTUBE: 16X9 
#RESOLUÇÃO IDEAL PARA YOUTUBE: 2560X1440
proporcao_youtube=$(echo "scale=4; 16/9" | bc -l )
echo $proporcao_youtube


nome_file=$(echo $path| cut -d'.' -f 1)
extensao=$(echo $path| cut -d'.' -f 2)

#CASO DÊ ERRO, SÓ INSTALAR O IMAGEMAGICK >> sudo apt-get install imagemagick -y 
largura=$(identify -format '%w' $path)
altura=$(identify -format '%h' $path)
largura_nova="$((largura * resize_percent/100))"
altura_nova="$((altura * resize_percent/100))"

echo $largura_nova
novo_nome="$nome_file""_""$largura_nova""x""$altura_nova"".""$extensao"
convert $path -resize "$largura_nova""x""$altura_nova" $novo_nome

if [[ "$crop_youtube" == "true" ]]; then  
  crop_youtube=$(echo "scale=4; $altura_nova - $largura_nova/($proporcao_youtube)" | bc -l )
  altura_nova_para_youtube=$(echo "scale=0; $largura_nova/($proporcao_youtube)" | bc -l )
  echo $altura_nova_para_youtube
  crop_south=$(echo "scale=0; $crop_youtube/2" | bc -l )
  crop_north=$(echo "scale=0; $crop_youtube/2" | bc -l )
  novo_nome_para_youtube="$nome_file""_""$largura_nova""x""$altura_nova_para_youtube"".""$extensao"
  echo $crop_north
  echo $crop_south  
  convert $novo_nome -gravity South -chop 0x$crop_south $novo_nome_para_youtube
  convert $novo_nome_para_youtube -gravity North -chop 0x$crop_north $novo_nome_para_youtube
  rm $novo_nome
  novo_nome=$novo_nome_para_youtube
fi

echo "Feito! Nome do arquivo:" "$novo_nome"
resolucao_novo_arquivo=$(identify -format '%wx%h' $novo_nome)
echo "Resolução: $resolucao_novo_arquivo" 