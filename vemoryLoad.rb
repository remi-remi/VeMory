#                   restore
#
# ( a excuter sur la machine proxmox)
#
def nettoyage(fichier)
  new_name = fichier.sub(/^.*vzdump-/, "vzdump-")
  `sudo mv #{fichier} #{new_name}`
  return "#{new_name}"
end

system("scp vemory@192.168.1.219:/home/vemory/backup/_*.vma.zst /home/vemory/tmpBac>
Dir.foreach("/home/vemory/tmpBackup/") do |file|
  if file =~ /^_([a-zA-Z]+)-[^-]+-[^-]+-(\d{3}).+.zst$/
    thisBacupPath="/home/vemory/tmpBackup/#{file}"
    `sudo qmrestore #{nettoyage(thisBacupPath)} #{$2} --force`
  end
end
