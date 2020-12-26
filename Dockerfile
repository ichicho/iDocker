FROM ubuntu:20.04
LABEL maintainer="Yichi Zhang <ichicho@keio.jp>"

# Change login shell to bash
SHELL ["/bin/bash", "-c"]

# Set timezone
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install basic tools
RUN apt update && \
    apt install -y --no-install-recommends \
                sudo \
                ca-certificates \
                curl \
                wget \
                git \
                less \
                vim-nox && \
    rm -rf /var/lib/apt/lists/*

# (Load ARGs from docker build command to fix permission problem
# when mounting files from host machine)
ARG user
ARG uid
ARG group
ARG gid
# Create user
RUN groupadd $group -g $gid && \
    useradd $user \
            -m -s /bin/bash \
            -u $uid \
            -g $group \
            -G sudo && \
    echo "$user ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/$user

# Install gcc, python, clang
COPY gcc_python_clang.sh /root/
RUN bash /root/gcc_python_clang.sh && \
    rm /root/gcc_python_clang.sh

# Change user
USER $user
WORKDIR /home/$user

RUN git clone https://github.com/ichicho/dotfiles.git && \
    bash dotfiles/deploy.sh && \
    bash dotfiles/initialize.sh

# Keep container running
CMD ["tail", "-f" ,"/dev/null"]
