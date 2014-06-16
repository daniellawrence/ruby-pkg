#!/usr/bin/env ruby

def get_list_kernels()
  cmd = "dpkg-query -W 'linux-image-*'"
  installed_kernels = []
  package_list = `#{cmd}`
  package_list.each_line do |line|
    (package_name,) = line.split()
    # Skip over packages are that not linux-images
    if not package_name.to_s.include? "linux-image-"
      next
    end
    
    # Skip over the virtual package
    if package_name.to_s.include? "linux-image-amd64"
      next
    end

    # show that we have a package-name that is a linux-image
    installed_kernels.push(package_name)
  end

  return installed_kernels.sort
end


def get_current_kernel()
  cmd = "uname -r"
  kernel_version = `#{cmd}`.strip
  return kernel_version
end

def running_latest_kernel(current_kernel, installed_kernels)
  latest_kernel = installed_kernels[-1]
  current_kernel = "linux-image-%s" % current_kernel
  if current_kernel == latest_kernel
    return true
  else
    return false
  end
end

# Make sure we are running the latest kernel
def main()
  
  installed_kernels = get_list_kernels()
  current_kernel = get_current_kernel()
  if running_latest_kernel(current_kernel, installed_kernels)
    puts "Gratz, you on the latest kernel"
    puts "delete the following kernels"
    installed_kernels[0...-1].each do |kernel|
      puts "- %s" % kernel
    end
  else
    puts "You need to reboot to get the latest kernel"
  end

  
end

main()

