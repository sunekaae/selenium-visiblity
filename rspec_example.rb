# from
# http://easyart.github.io/2012/05/01/using-selenium-and-rspec-for-behaviour-testing/
# 
# encoding: UTF-8
require "rubygems"
require "selenium-webdriver"
require "awesome_print"
 
# allow colour in RSpec results
RSpec.configure do |config| config.color_enabled = true end
  
test_url = "file:///Users/sune/Code/volvo/bitbucket/volvo-test-automation/ruby-selenium/test.html"
 
describe "The test site for element visibility" do
  before(:all) do
    # set up our driver and wait instances
    @driver = Selenium::WebDriver.for(:firefox)
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end
  after(:all) do
    # quit the browser after the tests run
    @driver.quit
  end
  
  it "should have the appropriate page title", :integration => true  do
    # navigate to the page
    @driver.get test_url
    # check the title is as expected
    @driver.title.should == "test page"
  end

  it "should have 1xh1 header 1xh2 headers and 4 paragraphs", :integration => true do
    @driver.get test_url
    # simply check total of each
    # TODO: consider doing check with ordering
    @driver.find_elements(:xpath, "//p").count.should == 4
    @driver.find_elements(:xpath, "//h1").count.should == 1
    @driver.find_elements(:xpath, "//h2").count.should == 1
  end
  
  it "will say that h2 is display'able even if outside of viewport", :integration => true do
    @driver.get test_url
    scale_browser_to_viewport(200, 50)
    element = @driver.find_element(:xpath, "//h2")
    element.displayed?.should == true
  end

  it "mark the element as not display'able when set to hidden", :integration => true do
    @driver.get test_url
    scale_browser_to_viewport(200, 50)
    @driver.find_element(:xpath, "//h2").displayed?.should == true
    @driver.execute_script("document.getElementsByTagName('h2')[0].style.visibility='hidden'")
    @driver.find_element(:xpath, "//h2").displayed?.should == false
  end
  
  it "mark the element as display'able even when negative Y coordinates", :integration => true do
    @driver.get test_url
    scale_browser_to_viewport(400, 200)
    @driver.find_element(:xpath, "//h2").displayed?.should == true
    @driver.execute_script("document.getElementsByTagName('h2')[0].style.position='absolute'")
    @driver.execute_script("document.getElementsByTagName('h2')[0].style.top='-100px'")
    @driver.find_element(:xpath, "//h2").displayed?.should == true
  end

  it "mark the element as not visible when negative Y coordinates", :integration1 => true do
    @driver.get test_url
    @driver.find_element(:xpath, "//h2").displayed?.should == true
    move_element_to_position(-100, nil)
#    @driver.execute_script("document.getElementsByTagName('h2')[0].style.position='absolute'")
#    @driver.execute_script("document.getElementsByTagName('h2')[0].style.top='-100px'")
    is_element_visible_if_scrolled(@driver.find_element(:xpath, "//h2")).should == false
  end

  it "will calculate size for browser", :unit => true do
    detemine_new_browser_size(800, 700, 1).should == 101
  end

  it "will correctly scale the browser", :integration => true do
    @driver.get test_url
    
    intended_height = 1
    intended_width = 300
    scale_browser_to_viewport(intended_width, intended_height)
    get_clientHeight.should == 1
    get_clientWidth.should == 300
  end
  
  def move_element_to_position x, y
    @driver.execute_script("document.getElementsByTagName('h2')[0].style.position='absolute'")
    if (!x.nil? ) then
      cmd = "document.getElementsByTagName('h2')[0].style.top='" + x.to_s + "px'"
      @driver.execute_script(cmd)
    end
    if (!y.nil?) then
      cmd = "document.getElementsByTagName('h2')[0].style.left='" + y.to_s + "px'"
      @driver.execute_script(cmd)
    end
    
  end
  
  def is_element_visible_if_scrolled element
    # check if any part of element is 0 or higher
    if (element.location.y + element.size.height < 0) then
      return false
    elsif (element.location.x + element.size.width < 0) then
      return false
    end
    return true
  end
  
  
  def scale_browser_to_viewport(viewport_width, viewport_height)
    # x
    new_x_size = detemine_new_browser_size(@driver.manage.window.size.width, get_clientWidth, viewport_width)
    puts "detemine_new_browser_size: " + new_x_size.to_s

    # y
    new_y_size = detemine_new_browser_size(@driver.manage.window.size.height, get_clientHeight, viewport_height)
    puts "detemine_new_browser_size: " + new_y_size.to_s

    @driver.manage.window.resize_to(new_x_size, new_y_size)
  end

  def detemine_new_browser_size current_browser_size, current_viewport, intended_viewport
    diff = current_browser_size - current_viewport
    return intended_viewport + diff
  end
  
  def get_clientWidth
    @driver.execute_script("return document.documentElement.clientWidth")
  end

  def get_clientHeight
    @driver.execute_script("return document.documentElement.clientHeight")
  end
  
    
end