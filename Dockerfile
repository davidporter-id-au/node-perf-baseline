FROM iojs

RUN mkdir -p /var/app/current
WORKDIR /var/app/current
ADD . /var/app/current
RUN npm install 
CMD npm start
