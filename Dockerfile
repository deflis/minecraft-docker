FROM centos:centos7


RUN curl -L --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" -o /tmp/jre.rpm http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jre-8u66-linux-x64.rpm
RUN yum localinstall -y /tmp/jre.rpm
RUN rm /tmp/jre.rpm

RUN mkdir /data
WORKDIR /data

RUN echo "eula=true" > /data/eula.txt
RUN curl -o /tmp/forge-installer.jar http://files.minecraftforge.net/maven/net/minecraftforge/forge/1.7.10-10.13.4.1448-1.7.10/forge-1.7.10-10.13.4.1448-1.7.10-installer.jar
RUN java -jar /tmp/forge-installer.jar nogui --installServer
RUN curl -o /data/minecraft_server.jar http://files.minecraftforge.net/maven/net/minecraftforge/forge/1.7.10-10.13.4.1448-1.7.10/forge-1.7.10-10.13.4.1448-1.7.10-universal.jar

COPY mods /data/mods
COPY config /data/config
COPY ops.txt /data
COPY server.properties /data
COPY server-icon.png /data

EXPOSE 25565
EXPOSE 25575
EXPOSE 3000
EXPOSE 8123

ENTRYPOINT ["java"]
CMD ["-Dcom.sun.management.jmxremote.port=3000", "-Dcom.sun.management.jmxremote.authenticate=false", "-Dcom.sun.management.jmxremote.ssl=false", "-Xmx2048m", "-jar", "minecraft_server.jar", "-server"]
