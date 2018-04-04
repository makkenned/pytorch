. env.sh
docker rm -f pytorch
nvidia-docker run -it --name pytorch -v /home/michael/data:/data -v /home/michael/notebooks:/notebooks -p 8888:8888 mk/pytorch
