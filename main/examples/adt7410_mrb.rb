include ESP32

class ADT7410
  def initialize(i2c, addr=0x48)
    @i2c = i2c
    @addr = addr
  end

  def ready?
    @i2c.ready?(@addr)
  end

  def receive
    word_data = @i2c.receive(2, @addr)
    first_bit = word_data[0].unpack("C*").first
    second_bit = word_data[1].unpack("C*").first
    ((first_bit << 8 | second_bit) >> 3) * 0.0625
  end
end

i2c = I2C.new(I2C::PORT0, scl: I2C::SCL1, sda: I2C::SDA1).init(I2C::MASTER)

temp = ADT7410.new(i2c)

i2c.scan

until temp.ready?
  p "waiting..."
  ESP32::System.delay(1000)
end

10.times do
  p temp.receive
  ESP32::System.delay(1000)
end

i2c.deinit
