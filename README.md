## Wunstrip : academic tests

You may compile and run those tests for wunstrip as follows:

jonathan@blackbox:~/these-validation/validation_wunstrip$ time make && time make test 
docker build . -t wcc-unstrip:latest
[+] Building 1092.9s (15/15) FINISHED                                                                                                                                          docker:default
 => [internal] load build definition from Dockerfile                                                                                                                                     0.0s
 => => transferring dockerfile: 865B                                                                                                                                                     0.0s
 => [internal] load metadata for docker.io/library/ubuntu:24.04                                                                                                                          0.8s
 => [auth] library/ubuntu:pull token for registry-1.docker.io                                                                                                                            0.0s
 => [internal] load .dockerignore                                                                                                                                                        0.0s
 => => transferring context: 2B                                                                                                                                                          0.0s
 => [1/9] FROM docker.io/library/ubuntu:24.04@sha256:353675e2a41babd526e2b837d7ec780c2a05bca0164f7ea5dbbd433d21d166fc                                                                    0.0s
 => [internal] load build context                                                                                                                                                        0.0s
 => => transferring context: 7.53kB                                                                                                                                                      0.0s
 => CACHED [2/9] WORKDIR /root                                                                                                                                                           0.0s
 => CACHED [3/9] RUN apt-get update &&     apt-get upgrade -y &&     apt-get install -y gnupg &&     apt-get clean                                                                       0.0s
 => CACHED [4/9] RUN echo "deb http://ddebs.ubuntu.com noble main restricted universe multiverse" > /etc/apt/sources.list.d/ddebs.list &&     apt-key adv --keyserver keyserver.ubuntu.  0.0s
 => CACHED [5/9] RUN apt-get update &&     apt-get install -y clang libbfd-dev uthash-dev libelf-dev libcapstone-dev sudo     libreadline-dev libiberty-dev libgsl-dev build-essential   0.0s
 => [6/9] COPY ./testcases /root                                                                                                                                                         0.4s
 => [7/9] RUN dpkg -i ./apps/*deb                                                                                                                                                       29.9s
 => [8/9] RUN make prepare                                                                                                                                                               0.3s 
 => [9/9] RUN make                                                                                                                                                                    1059.4s 
 => exporting to image                                                                                                                                                                   1.9s 
 => => exporting layers                                                                                                                                                                  1.9s 
 => => writing image sha256:6fa6504c0755a9f7fb2d605f4b4160081503e90b9f8a2133949c0480e07c4858                                                                                             0.0s 
 => => naming to docker.io/library/wcc-unstrip:latest                                                                                                                                    0.0s 
                                                                                                                                                                                              
real    18m13.038s                                                                                                                                                                            
user	0m1.370s
sys	0m0.769s
docker run -it --user 0 wcc-unstrip:latest bash -c "make test"
echo -e "\n [*] Testing /bin/ls\n"
-e 
 [*] Testing /bin/ls

checksec --file=/bin/ls
RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH	Symbols		FORTIFY	Fortified	Fortifiable	FILE
Full RELRO      Canary found      NX enabled    PIE enabled     No RPATH   No RUNPATH   No Symbols	  Yes	9		19		/bin/ls
./test_ls.sh
 -- Recovered functions:
185
 -- Valid functions recovered:
185
 -- Number of functions we should have found:
191
./false_positives.sh ls
./false_negatives.sh ls
ERROR: 0000000000006dd0 t __do_global_dtors_aux: 0
ERROR: 0000000000006d60 t deregister_tm_clones: 0
ERROR: 0000000000006e10 t frame_dummy: 0
ERROR: 0000000000006d90 t register_tm_clones: 0
echo -e "\n [*] Testing /usr/sbin/nginx\n"
-e 
 [*] Testing /usr/sbin/nginx

checksec --file=/usr/sbin/nginx
RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH	Symbols		FORTIFY	Fortified	Fortifiable	FILE
Full RELRO      Canary found      NX enabled    PIE enabled     No RPATH   No RUNPATH   No Symbols	  Yes	4		11		/usr/sbin/nginx
./test_nginx.sh
 -- Recovered functions:
1657
 -- Valid functions recovered:
1657
 -- Number of functions we should have found:
1663
./false_positives.sh nginx
./false_negatives.sh nginx
ERROR: 0000000000026d30 t __do_global_dtors_aux: 0
ERROR: 00000000000f5100 t _fini: 0
ERROR: 0000000000023000 t _init: 0
ERROR: 0000000000026cc0 t deregister_tm_clones: 0
ERROR: 0000000000026d70 t frame_dummy: 0
ERROR: 0000000000026cf0 t register_tm_clones: 0
echo -e "\n [*] Testing /usr/sbin/sshd\n"
-e 
 [*] Testing /usr/sbin/sshd

checksec --file=/usr/sbin/sshd
RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH	Symbols		FORTIFY	Fortified	Fortifiable	FILE
Full RELRO      Canary found      NX enabled    PIE enabled     No RPATH   No RUNPATH   No Symbols	  Yes	14		28		/usr/sbin/sshd
./test_sshd.sh
 -- Recovered functions:
828
 -- Valid functions recovered:
828
 -- Number of functions we should have found:
834
./false_positives.sh sshd
./false_negatives.sh sshd
ERROR: 0000000000014a10 t __do_global_dtors_aux: 0
ERROR: 00000000000149a0 t deregister_tm_clones: 0
ERROR: 0000000000014a50 t frame_dummy: 0
ERROR: 00000000000149d0 t register_tm_clones: 0
echo -e "\n [*] Testing /lib/x86_64-linux-gnu/libjpeg.so.9.5.0\n"
-e 
 [*] Testing /lib/x86_64-linux-gnu/libjpeg.so.9.5.0

checksec --file=/lib/x86_64-linux-gnu/libjpeg.so.9.5.0
RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH	Symbols		FORTIFY	Fortified	Fortifiable	FILE
Partial RELRO   Canary found      NX enabled    DSO             No RPATH   No RUNPATH   No Symbols	  Yes	3		6		/lib/x86_64-linux-gnu/libjpeg.so.9.5.0
./test_libjpeg.sh
 -- Recovered functions:
363
 -- Valid functions recovered:
363
 -- Number of functions we should have found:
369
./false_positives.sh libjpeg.so.9.5.0
./false_negatives.sh libjpeg.so.9.5.0
ERROR: 0000000000005980 t __do_global_dtors_aux: 0
ERROR: 0000000000033868 t _fini: 0
ERROR: 0000000000005000 t _init: 0
ERROR: 0000000000005910 t deregister_tm_clones: 0
ERROR: 00000000000059c0 t frame_dummy: 0
ERROR: 0000000000005940 t register_tm_clones: 0
echo -e "\n [*] Testing /usr/sbin/mysql\n"
-e 
 [*] Testing /usr/sbin/mysql

checksec --file=/usr/sbin/mysqld
RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH	Symbols		FORTIFY	Fortified	Fortifiable	FILE
Full RELRO      Canary found      NX enabled    PIE enabled     No RPATH   No RUNPATH   No Symbols	  Yes	18		42		/usr/sbin/mysqld
./test_mysqld.sh
 -- Recovered functions:
61873
 -- Valid functions recovered:
61873
 -- Number of functions we should have found:
61879
./false_positives.sh mysqld
./false_negatives.sh mysqld
ERROR: 00000000009f44f0 t __do_global_dtors_aux: 0
ERROR: 000000000201cc78 t _fini: 0
ERROR: 00000000008c3000 t _init: 0
ERROR: 00000000009f4480 t deregister_tm_clones: 0
ERROR: 00000000009f4530 t frame_dummy: 0
ERROR: 00000000009f44b0 t register_tm_clones: 0
echo -e "\n [*] Testing /usr/sbin/proftpd\n"
-e 
 [*] Testing /usr/sbin/proftpd

checksec --file=/usr/sbin/proftpd
RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH	Symbols		FORTIFY	Fortified	Fortifiable	FILE
Full RELRO      Canary found      NX enabled    PIE enabled     No RPATH   No RUNPATH   No Symbols	  Yes	19		37		/usr/sbin/proftpd
./test_proftpd.sh
 -- Recovered functions:
1995
 -- Valid functions recovered:
49
 -- Number of functions we should have found:
2001
./false_positives.sh proftpd
./false_negatives.sh proftpd
ERROR: 0000000000020780 t __do_global_dtors_aux: 0
ERROR: 00000000000e7a4c t _fini: 0
ERROR: 000000000001d000 t _init: 0
ERROR: 0000000000020710 t deregister_tm_clones: 0
ERROR: 00000000000207c0 t frame_dummy: 0
ERROR: 0000000000020740 t register_tm_clones: 0
echo -e "\n [*] Testing /usr/sbin/smbd\n"
-e 
 [*] Testing /usr/sbin/smbd

checksec --file=/usr/sbin/smbd
RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH	Symbols		FORTIFY	Fortified	Fortifiable	FILE
Full RELRO      Canary found      NX enabled    PIE enabled     No RPATH   RW-RUNPATH   No Symbols	  Yes	1		2		/usr/sbin/smbd
./test_smbd.sh
 -- Recovered functions:
42
 -- Valid functions recovered:
0
 -- Number of functions we should have found:
48
./false_positives.sh smbd
./false_negatives.sh smbd
ERROR: 0000000000008b10 t __do_global_dtors_aux: 0
ERROR: 000000000000bd74 t _fini: 0
ERROR: 0000000000005000 t _init: 0
ERROR: 0000000000008aa0 t deregister_tm_clones: 0
ERROR: 0000000000008b50 t frame_dummy: 0
ERROR: 0000000000008ad0 t register_tm_clones: 0
echo -e "\n [*] Testing /usr/lib/postgresql/16/bin/postgres\n"
-e 
 [*] Testing /usr/lib/postgresql/16/bin/postgres

checksec --file=/usr/lib/postgresql/16/bin/postgres
RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH	Symbols		FORTIFY	Fortified	Fortifiable	FILE
Full RELRO      Canary found      NX enabled    PIE enabled     No RPATH   No RUNPATH   No Symbols	  Yes	14		33		/usr/lib/postgresql/16/bin/postgres
./test_postgres.sh
 -- Recovered functions:
18320
 -- Valid functions recovered:
9
 -- Number of functions we should have found:
18324
./false_positives.sh postgres
ERROR: 0000000000268d30 T function_parse_error_transpose: 0
ERROR: 0000000000476850 T function_selectivity: 0
./false_negatives.sh postgres
ERROR: 000000000015f8c0 t __do_global_dtors_aux: 0
ERROR: 000000000071b0e4 t _fini: 0
ERROR: 00000000000d2000 t _init: 0
ERROR: 000000000015f850 t deregister_tm_clones: 0
ERROR: 000000000015f900 t frame_dummy: 0
ERROR: 000000000015f880 t register_tm_clones: 0
echo -e "\n [*] Testing /usr/bin/vlc\n"
-e 
 [*] Testing /usr/bin/vlc

checksec --file=/usr/bin/vlc
RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH	Symbols		FORTIFY	Fortified	Fortifiable	FILE
Full RELRO      Canary found      NX enabled    PIE enabled     No RPATH   No RUNPATH   No Symbols	  Yes	2		3		/usr/bin/vlc
./test_vlc.sh
 -- Recovered functions:
9
 -- Valid functions recovered:
9
 -- Number of functions we should have found:
15
./false_positives.sh vlc
./false_negatives.sh vlc
ERROR: 0000000000001980 t __do_global_dtors_aux: 0
ERROR: 0000000000001910 t deregister_tm_clones: 0
ERROR: 00000000000019c0 t frame_dummy: 0
ERROR: 0000000000001940 t register_tm_clones: 0
echo -e "\n [*] Testing /lib/x86_64-linux-gnu/liblzma.so.5\n"
-e 
 [*] Testing /lib/x86_64-linux-gnu/liblzma.so.5

checksec --file=/lib/x86_64-linux-gnu/liblzma.so.5
RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH	Symbols		FORTIFY	Fortified	Fortifiable	FILE
Full RELRO      Canary found      NX enabled    DSO             No RPATH   No RUNPATH   No Symbols	  No	0		3		/lib/x86_64-linux-gnu/liblzma.so.5
./test_liblzma.sh
 -- Recovered functions:
322
 -- Valid functions recovered:
322
 -- Number of functions we should have found:
328
./false_positives.sh liblzma.so.5
./false_negatives.sh liblzma.so.5
ERROR: 0000000000003520 t __do_global_dtors_aux: 0
ERROR: 00000000000245d0 t _fini: 0
ERROR: 0000000000003000 t _init: 0
ERROR: 00000000000034b0 t deregister_tm_clones: 0
ERROR: 0000000000003560 t frame_dummy: 0
ERROR: 00000000000034e0 t register_tm_clones: 0

real	392m26.140s
user	0m0.350s
sys	0m0.050s
jonathan@blackbox:~/these-validation/validation_wunstrip$ 
