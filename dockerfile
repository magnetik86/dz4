# Используем официальный образ Ubuntu
FROM ubuntu:latest

# Выполняем обновление apt-кеша и обновление всех пакетов
RUN apt-get update && apt-get upgrade -y

# Устанавливаем веб-сервер nginx
RUN apt-get install -y nginx

# Очищаем скачанный apt-cache
RUN apt-get clean

# Удаляем содержимое директории /var/www/
RUN rm -rf /var/www/*

# Создаем директорию /var/www/company.com и в ней папку img
RUN mkdir -p /var/www/company.com/img

# Помещаем файл index.html в директорию /var/www/company.com
COPY index.html /var/www/company.com/index.html

# Помещаем файл image.png в директорию /var/www/company.com/img
COPY image.png /var/www/company.com/img/image.png

# Задаем права на папку /var/www/company.com
RUN chmod -R 754 /var/www/company.com

# Создаем пользователя simon
RUN useradd -m simon

# Создаем группу wsizov
RUN groupadd sizov

# Помещаем пользователя www-user в группу www-group
RUN usermod -aG sizov simon

# Присваиваем права на папку /var/www/company.com
RUN chown -R simon:sizov /var/www/company.com

# Заменяем подстроку в файле /etc/nginx/sites-enabled/default
RUN sed -i 's|/var/www/html|/var/www/company.com|g' /etc/nginx/sites-enabled/default

# Заменяем пользователя в файле /etc/nginx/nginx.conf на simon
RUN sed -i 's|user www-data|user  simon|g' /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]

