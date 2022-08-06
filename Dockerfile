FROM rocker/rstudio:latest

WORKDIR /home/repos

RUN install2.r --error \
--deps TRUE \
data.table \
lpSolve


CMD bash launch.sh