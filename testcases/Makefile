all::
	cp /bin/ls /root/
	wunstrip /root/ls -d -o ls.dbg
	wunstrip /root/ls -e -o /root/ls.unstripped

	cp /usr/sbin/nginx /root/
	wunstrip /root/nginx -d -o /root/nginx.dbg
	wunstrip /root/nginx -e -o /root/nginx.unstripped

	cp /usr/sbin/sshd /root/
	wunstrip /root/sshd -d -o /root/sshd.dbg
	wunstrip /root/sshd -e -o /root/sshd.unstripped

	cp /usr/sbin/mysqld /root/
	wunstrip /root/mysqld -d -o /root/mysqld.dbg
	wunstrip /root/mysqld -e -o /root/mysqld.unstripped

	cp /lib/x86_64-linux-gnu/libjpeg.so.9.5.0 /root/
	wunstrip /root/libjpeg.so.9.5.0 -d -o /root/libjpeg.so.9.5.0.dbg
	wunstrip /root/libjpeg.so.9.5.0 -e -o /root/libjpeg.so.9.5.0.unstripped

	cp /usr/sbin/proftpd /root/
	wunstrip /root/proftpd -d -o /root/proftpd.dbg
	wunstrip /root/proftpd -e -o /root/proftpd.unstripped

	cp /usr/sbin/smbd /root/
	wunstrip /root/smbd -d -o /root/smbd.dbg
	wunstrip /root/smbd -e -o /root/smbd.unstripped

	cp /usr/lib/postgresql/16/bin/postgres /root/
	wunstrip /root/postgres -d -o /root/postgres.dbg
	wunstrip /root/postgres -e -o /root/postgres.unstripped

	cp /usr/bin/vlc /root/
	wunstrip /root/vlc -d -o /root/vlc.dbg
	wunstrip /root/vlc -e -o /root/vlc.unstripped

	cp /lib/x86_64-linux-gnu/liblzma.so.5 /root/
	wunstrip /root/liblzma.so.5 -d -o /root/liblzma.so.5.dbg
	wunstrip /root/liblzma.so.5 -e -o /root/liblzma.so.5.unstripped

prepare::
	cp build/libLIEF.so /lib/x86_64-linux-gnu/libLIEF.so
	cp build/libbfd-2.45.so /lib/x86_64-linux-gnu/
	cp build/libsframe.so.2 /lib/x86_64-linux-gnu/
	cp build/wunstrip /usr/bin/

clean::
	rm -f /root/ls /root/ls.dbg /root/ls.unstripped
	rm -f /root/nginx /root/nginx.dbg /root/nginx.unstripped
	rm -f /root/sshd /root/sshd.dbg /root/sshd.unstripped
	rm -f /root/mysqld /root/mysqld.dbg /root/mysqld.unstripped

test::
	echo -e "\n [*] Testing /bin/ls\n"
	checksec --file=/bin/ls
	./test_ls.sh
	./false_positives.sh ls
	./false_negatives.sh ls
	echo -e "\n [*] Testing /usr/sbin/nginx\n"
	checksec --file=/usr/sbin/nginx
	./test_nginx.sh
	./false_positives.sh nginx
	./false_negatives.sh nginx
	echo -e "\n [*] Testing /usr/sbin/sshd\n"
	checksec --file=/usr/sbin/sshd
	./test_sshd.sh
	./false_positives.sh sshd
	./false_negatives.sh sshd
	echo -e "\n [*] Testing /lib/x86_64-linux-gnu/libjpeg.so.9.5.0\n"
	checksec --file=/lib/x86_64-linux-gnu/libjpeg.so.9.5.0
	./test_libjpeg.sh
	./false_positives.sh libjpeg.so.9.5.0
	./false_negatives.sh libjpeg.so.9.5.0
	echo -e "\n [*] Testing /usr/sbin/mysql\n"
	checksec --file=/usr/sbin/mysqld
	./test_mysqld.sh
	./false_positives.sh mysqld
	./false_negatives.sh mysqld
	echo -e "\n [*] Testing /usr/sbin/proftpd\n"
	checksec --file=/usr/sbin/proftpd
	./test_proftpd.sh
	./false_positives.sh proftpd
	./false_negatives.sh proftpd
	echo -e "\n [*] Testing /usr/sbin/smbd\n"
	checksec --file=/usr/sbin/smbd
	./test_smbd.sh
	./false_positives.sh smbd
	./false_negatives.sh smbd
	echo -e "\n [*] Testing /usr/lib/postgresql/16/bin/postgres\n"
	checksec --file=/usr/lib/postgresql/16/bin/postgres
	./test_postgres.sh
	./false_positives.sh postgres
	./false_negatives.sh postgres
	echo -e "\n [*] Testing /usr/bin/vlc\n"
	checksec --file=/usr/bin/vlc
	./test_vlc.sh
	./false_positives.sh vlc
	./false_negatives.sh vlc
	echo -e "\n [*] Testing /lib/x86_64-linux-gnu/liblzma.so.5\n"
	checksec --file=/lib/x86_64-linux-gnu/liblzma.so.5
	./test_liblzma.sh
	./false_positives.sh liblzma.so.5
	./false_negatives.sh liblzma.so.5

