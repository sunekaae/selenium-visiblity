require 'selenium-webdriver'

def gogo_selenium
  puts 'gogo_selenium'
end

def start_selenium
  @browser = Selenium::WebDriver.for(:firefox)
  @browser.get(get_local_url)
  @browser.manage.window.resize_to(200, 200)
  puts 'browser instance available in $browser'
end

def get_local_url
  File.join("file://", Dir.pwd, "test.html")
end

def get_clientWidth
  @browser.execute_script("return document.documentElement.clientWidth")
end

def get_clientHeight
  @browser.execute_script("return document.documentElement.clientHeight")
end


# useful highlight code for ruby *
# https://gist.github.com/marciomazza/3086536
def highlight(method, locator, ancestors=0)
  @element = $browser.find_element(method, locator)
  highlight_element($element)
end

def highlight_element(element, ancestors=0)
  @browser.execute_script("hlt = function(c) { c.style.border='solid 2px rgb(255, 16, 16)'; }; return hlt(arguments[0]);", element)
  parents = ""
  red = 255

  ancestors.times do
    parents << ".parentNode"
    red -= (12*8 / ancestors)
    @browser.execute_script("hlt = function(c) { c#{parents}.style.border='solid 1px rgb(#{red}, 0, 0)'; }; return hlt(arguments[0]);", element)
  end
end

gogo_selenium
