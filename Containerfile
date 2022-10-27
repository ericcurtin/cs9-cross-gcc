FROM centos:stream9

RUN dnf install -y epel-release
RUN dnf install -y gcc-c++-aarch64-linux-gnu xz
RUN cd /usr/aarch64-linux-gnu/ && \
    curl -OL https://cloud.centos.org/centos/9-stream/aarch64/images/CentOS-Stream-Container-Base-9-20220919.0.aarch64.tar.xz && \
    cd sys-root && \
    tar -xOf ../CentOS-Stream-Container-Base-9-20220919.0.aarch64.tar.xz --wildcards --no-anchored 'layer.tar' | tar xf - && \
    rm -rf CentOS-Stream-Container-Base-9-20220919.0.aarch64.tar.xz
WORKDIR "/usr/aarch64-linux-gnu/sys-root"
RUN dnf install -y --forcearch=aarch64 --installroot=$PWD --releasever=9 gcc-toolset-12-libstdc++-devel glibc-headers || true
RUN mkdir -p /usr/lib/gcc/aarch64-linux-gnu/12/../../../../aarch64-linux-gnu/include/
RUN cp -r opt/rh/gcc-toolset-12/root/usr/include/c++ /usr/lib/gcc/aarch64-linux-gnu/12/../../../../aarch64-linux-gnu/include/
RUN mv /usr/lib/gcc/aarch64-linux-gnu/12/../../../../aarch64-linux-gnu/include/c++/12/aarch64-redhat-linux /usr/lib/gcc/aarch64-linux-gnu/12/../../../../aarch64-linux-gnu/include/c++/12/aarch64-linux-gnu
RUN cp opt/rh/gcc-toolset-12/root/usr/lib/gcc/aarch64-redhat-linux/12/* usr/lib64/
RUN echo -e "#include <iostream>\n int main() { std::cout << \"Some dynamically linked cross-compiled C++ application\\\n\"; return 0; }" > a.cpp && aarch64-linux-gnu-g++ a.cpp && rm -rf a.cpp a.out # just a test

