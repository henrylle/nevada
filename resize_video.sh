video_path=$1
crop_to=$2
clean_temp_folder=true
#name_video_path=$(basename $video_path)
nome_file=$(echo $video_path | cut -d'.' -f 1)
extensao=$(echo $video_path| cut -d'.' -f 2)


error_output() {
  echo 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
  echo "ERROR! ==> $1";
  echo 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
  exit 1;
}

check_error() {
  if [ $? != 0 ]; then
    error_output "Erro ao renderizar video..."
    exit 1;
  fi
}

log_level_ffmpeg="-loglevel error"
if [ ! -z $VERBOSE ] && [ $VERBOSE == "true" ]; then
  log_level_ffmpeg=""
fi
check_error


opcoes_validas="facebook_feed, facebook_stories, instagram_feed, instragram_stories"
if [ -z "$crop_to" ]; then
  echo "Informe o crop de destino. Opcoes validas: $opcoes_validas"
  exit 1;
fi

if [ "$crop_to" != "facebook_feed" ] && [ "$crop_to" != "facebook_stories" ] && [ "$crop_to" != "instagram_feed" ] && [ "$crop_to" != "instagram_stories" ]; then
  echo "$crop_to nao eh um crop de destino valido. Opcoes validas: $opcoes_validas"
  exit 1;
fi

height_original_video=$(ffprobe -v error -show_entries stream=height -of csv=p=0:s=x $video_path)
width_original_video=$(ffprobe -v error -show_entries stream=width -of csv=p=0:s=x $video_path)

case $crop_to in
  facebook_feed) width_new_video=1080;height_new_video=1080;crop_left=420;crop_top=0 ;;
  facebook_stories) proporcao_destino=$proporcao_facebook_stories ;;
  instagram_feed) width_new_video=1080;height_new_video=1080;crop_left=420;crop_top=0 ;;
  instagram_stories) proporcao_destino=$proporcao_instagram_stories ;;
esac

config_scale_video="crop=$width_new_video:$height_new_video:$crop_left:$crop_top"

final_video_path="$nome_file""_"$crop_to"_""$width_new_video""x""$height_new_video"".""$extensao"
path_image_example="$nome_file""_screenshot_"$crop_to"_""$width_new_video""x""$height_new_video"".jpg"



##Extrair Video Quadrado
if [ ! -z $PREVIEW ] && [ $PREVIEW == "true" ]; then
  ffmpeg -i $video_path -t 10 -vf "$config_scale_video" -vframes 1 -q:v 0 $path_image_example -y
  ffmpeg -i $path_image_example -t 10 -vf "color=red@0.5:60x60 [c]; [in][c] overlay=$width_new_video/2:$height_new_video/2" -vframes 1 -q:v 2 $path_image_example -y
  eog $path_image_example  
else
  printf "Gerando vídeo para o formato $crop_to na resolucao $width_new_video:$height_new_video"
  ffmpeg -i $video_path -vf "$config_scale_video" -c:a copy -c:v libx264 -crf 0 $final_video_path -y
  check_error
  printf 'OK\n'  
  ffplay $final_video_path
fi