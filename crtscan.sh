#!/bin/bash
url_base="https://crt.sh/?q=";
params=$1;
url_params="${url_base}${params}";

echo -e "\n Buscando ${url_params}";
curl_out=$(curl -s 'https://crt.sh/?q=gob.mx' | grep '<TD' | grep -vE 'style' | tr '<BR>' '\n' | tr -d '/TD' | xargs | tr ' ' '\n' | grep -v '*' | sponge curl_out_txt);
domains=(cat curl_out_txt);

file_path="./curl_out_txt";
echo $file_path;
while IFS= read -r domain; do
  response_code=$(curl -s --max-time 2 -o /dev/null -w "%{http_code}" "http://${domain}");
  response_code2=$(curl -s --max-time 2 -o /dev/null -w "%{http_code}" "https://${domain}");
  
  if [ "$response_code" -eq 200 ]; then
    echo "Dominio $domain retorna 200 OK";
  else
    echo "Dominio $domain retorna $response_code";
  fi

  if [ "$response_code2" -eq 200 ]; then
    echo "Dominio con HTTPS $domain retorna 200 OK";
  else
    echo "Dominio $domain retorna $response_code";
  fi

done < "$file_path";
