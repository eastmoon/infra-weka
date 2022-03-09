FROM openjdk:17.0.2-slim

# Install tools
RUN \
    apt-get update -y && \
    apt-get install -y \
        curl \
        unzip

# Declare variable
ENV WEKA_VERSION=weka-3-8-6

# Download Weka package
RUN \
    curl --location https://prdownloads.sourceforge.net/weka/${WEKA_VERSION}.zip --output weka.zip

# Unzip Weka package
RUN \
    unzip weka.zip && rm weka.zip

WORKDIR /${WEKA_VERSION}
ENTRYPOINT ["java", "--add-opens", "java.base/java.lang=ALL-UNNAMED", "-classpath", "weka.jar"]
