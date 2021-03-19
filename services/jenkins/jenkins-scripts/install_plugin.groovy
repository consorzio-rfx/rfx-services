def installed = false 
def plugins = ['script-security', 
               'command-launcher', 
               'docker-plugin',
               'docker-workflow',
               'gitlab-plugin',
               'gitlab-api'
               ]

def instance =Jenkins.getInstance() 
def pm = instance.getPluginManager() 
def uc = instance.getUpdateCenter() 
uc.updateAllSites()

println("hello");

plugins.each {
  println(it)
  if(!pm.getPlugin(it)) {
    def plugin = uc.getPlugin(it)
    if (plugin) {
      println("installing plugin "+plugin)
      plugin.deploy()
      installed = true
    } else {
      println("plugin "+it+" not found in list")
    }
  } else {
    println("plugin "+it+" already installed")
  }
}

if (installed) {  
  instance.save()  
  println("RESTARTIN JENKINS")
  instance.doSafeRestart() // do not restart here as we put this in the init script, it will run into an infinite loop
}
