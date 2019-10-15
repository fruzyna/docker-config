FROM nginx
RUN apt-get update && apt-get install -y git
RUN rm -rf /usr/share/nginx/html
RUN git clone https://github.com/mail929/OTD-Calcs-Web.git /usr/share/nginx/html
