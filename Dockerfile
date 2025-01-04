FROM ubuntu

RUN apt-get update && apt-get install -y snapd

RUN systemctl unmask snapd.service
RUN systemctl enable snapd.service
RUN systemctl start snapd.service

RUN snap install --beta zig --classic

CMD ["tail", "-f", "/dev/null"]
