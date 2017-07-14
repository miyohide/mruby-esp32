class ADT7410
  def initialize(i2c, addr=0x48)
    @i2c = i2c
    @addr = addr
  end

  def ready
    @i2c.ready?(@addr)
  end

  def receive
    word_data = @i2c.receive(2, @addr)
    ((word_data[0] << 8 | word_data[1]) >> 3) * 0.0625
  end
end

i2c = I2c.new(I2C::PORT0).init(I2C::MASTER)

p i2c.scan

temp = ADT7410.new(i2c)

until temp.ready?
  ESP32::System.delay(1000)
end

100.times do
  p temp.receive
  ESP32::System.delay(1000)
end

i2c.deinit
