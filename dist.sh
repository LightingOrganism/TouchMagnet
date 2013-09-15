tar -cvzhf TouchMagnetLinux32.tgz TouchMagnetLinux32
rsync -avP TouchMagnetLinux32.tgz -e ssh lightingorganism.com:/var/dist/
