path=$1
resize_percent=$2
crop_to=$3

opcoes_validas="facebook_feed, facebook_stories, instagram_feed, instragram_stories"
if [ -z "$crop_to" ]; then
  echo "Informe o crop de destino. Opcoes validas: $opcoes_validas"
  exit 1;
fi

if [ "$crop_to" != "facebook_feed" ] && [ "$crop_to" != "facebook_stories" ] && [ "$crop_to" != "instagram_feed" ] && [ "$crop_to" != "instagram_stories" ]; then
  echo "$crop_to nao eh um crop de destino valido. Opcoes validas: $opcoes_validas"
  exit 1;
fi

#ASPECT RATIO IDEAL PARA YOUTUBE: 16X9 
#RESOLUÇÃO IDEAL PARA YOUTUBE: 2560X1440
proporcao_facebook_feed=$(echo "scale=2; 1.91/1" | bc -l )
proporcao_facebook_stories=$(echo "scale=4; 9/16" | bc -l )
proporcao_instagram_feed=$(echo "scale=2; 1/1" | bc -l )
proporcao_instagram_stories=$(echo "scale=4; 9/16" | bc -l )

case $crop_to in
  facebook_feed) proporcao_destino=$proporcao_facebook_feed ;;
  facebook_stories) proporcao_destino=$proporcao_facebook_stories ;;
  instagram_feed) proporcao_destino=$proporcao_instagram_feed ;;
  instagram_stories) proporcao_destino=$proporcao_instagram_stories ;;
esac

echo $proporcao_destino
nome_file=$(echo $path| cut -d'.' -f 1)
extensao=$(echo $path| cut -d'.' -f 2)

#CASO DÊ ERRO, SÓ INSTALAR O IMAGEMAGICK >> sudo apt-get install imagemagick -y 
largura=$(identify -format '%w' $path)
altura=$(identify -format '%h' $path)
largura_nova="$((largura * resize_percent/100))"
altura_nova="$((altura * resize_percent/100))"

echo $altura_nova
novo_nome="$nome_file""_"$crop_to"_""$largura_nova""x""$altura_nova"".""$extensao"
echo $novo_nome
convert $path -resize "$largura_nova""x""$altura_nova" $novo_nome


if (( $(echo "$proporcao_destino > 1" | bc -l) )); then
  echo 'aqui regula a altura e já tá pronto'
else
  echo 'aqui regula a largura e não tá pronto'
  exit 1;
fi


crop_destino=$(echo "scale=4; $altura_nova - $largura_nova/($proporcao_destino)" | bc -l )
altura_nova_para_youtube=$(echo "scale=0; $largura_nova/($proporcao_destino)" | bc -l )
echo $altura_nova_para_youtube
crop_south=$(echo "scale=0; $crop_destino/2" | bc -l )
crop_north=$(echo "scale=0; $crop_destino/2" | bc -l )
novo_nome_para_dest_escolhido="$nome_file""_"$crop_to"_""$largura_nova""x""$altura_nova_para_youtube"".""$extensao"
echo $crop_north
echo $crop_south  
convert $novo_nome -gravity South -chop 0x$crop_south $novo_nome_para_dest_escolhido
convert $novo_nome_para_dest_escolhido -gravity North -chop 0x$crop_north $novo_nome_para_dest_escolhido
rm $novo_nome
novo_nome=$novo_nome_para_dest_escolhido

echo "Feito! Nome do arquivo:" "$novo_nome"
resolucao_novo_arquivo=$(identify -format '%wx%h' $novo_nome)
echo "Resolução: $resolucao_novo_arquivo" 