#                   backup               
#
# (a executer avec un anacron en local sur la machine proxmox)
# vide le dossier de sauvegarde locale (cote proxmox) pui lance la sauvegarde pour chaque VM en ajoutant le nom et l'ID
`sudo rm /var/lib/vz/dump/*`
folder_path = "/var/lib/vz/dump/"
output = `sudo qm list`
output.each_line do |line|
  if line =~ /[^\d](\d\d\d)\s([A-z]+)/
    puts "virtual machine : #{$2} \n id: #{$1} starting backup.."         #test
    `sudo vzdump #{$1} --mode stop --node pve --compress zstd --remove 0`
    `sudo rm /var/lib/vz/dump/*.log` #! SUPRESSION DU LOG
    file = Dir.entries(folder_path).select {|f| !File.directory? f}.first
    new_file = "_#{$2}-#{file}"
    `mv /var/lib/vz/dump/*.vma.zst /home/vemory/tmpBackup/#{new_file}`
  end
end
`scp /home/vemory/tmpBackup/*.vma.zst vemory@192.168.1.219:/home/vemory/backup/`
`rm /home/vemory/tmpBackup/*`
