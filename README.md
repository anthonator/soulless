# Soulless

Rails models without the database (and Rails). Great for implementing the form object pattern.

[![Build Status](https://travis-ci.org/anthonator/soulless.png?branch=master)](https://travis-ci.org/anthonator/soulless) [![Dependency Status](https://gemnasium.com/anthonator/soulless.png)](https://gemnasium.com/anthonator/soulless)
 [![Coverage Status](https://coveralls.io/repos/anthonator/soulless/badge.png?branch=master)](https://coveralls.io/r/anthonator/soulless?branch=master) [![Code Climate](https://codeclimate.com/github/anthonator/soulless.png)](https://codeclimate.com/github/anthonator/soulless)

## Installation

Add this line to your application's Gemfile:

    gem 'soulless'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install soulless

## Usage

Just define a plain-old-ruby-object, include Soulless and get crackin'!

```ruby
class UserSignupForm
  include Soulless.model
  
  attribute :name, String
  attribute :email, String
  attribute :password, String
  
  validates :name, presence: true
  
  validates :email, presence: true,
                    uniqueness: { model: User }
  
  validates :password, presence: true,
                       lenght: { is_at_least: 8 }

  private
  def persist!
    # Define what to do when this form is ready to be saved.
  end
end
```

### Default Values

When defining attributes it's possible to specify default values.

```ruby
class UserSignupForm

  ...
  
  attribute :name, String, default: 'Anthony'
  
  ...
end
```

### Embedded Values

It's possible to use other Soulless objects as attribute types.

```ruby
class User
  include Soulless.model

  attribute :name, String
  attribute :email, String
  attribute :password, String
end

class UserSignupForm
  include Soulless.model
  
  attribute :user, User
end
```

### Collection Coercions

Define collections with specific types.

```ruby
class PhoneNumber
  include Soulless.model
  
  attribute :number, String
end

class Person
  include Soulless.model
  
  attribute :phone_numbers, Array[PhoneNumber]
end
```

### Processing an Object

Soulless let's _you_ define what happens when your object is ready to be processed.

```ruby
class UserSignupForm

  ...
  
  private
  def persist!
    user = User.create!(name: name, email: email, password: password)
    UserMailer.send_activation_code(user).deliver
    user.charge_card!
  end
end
```

Process your Soulless object by calling ```save```. Just like a Rails model!

```ruby
form = UserSignupForm.new(name: name, email: email, password: passord)
if form.save
  # Called persist! and all is good!
else
  # Looks like a validation failed. Try again.
end
```

### Validations and Errors

Soulless lets you define your validations and manage your errors just like you did in Rails.

```ruby
class UserSignupForm

  ...
  
  validates :name, presence: true
  
  validates :email, presence: true,
                    uniqueness: { model: User }
  
  validates :password, presence: true,
                       lenght: { minimum: 8 }

  ...

end
```

Check to see if your object is valid by calling ```valid?```.

```ruby
form = UserSignupForm.new(name: name, email: email)
form.valid? # => false
```

See what errors are popping up using the ```errors``` attribute.

```ruby
form = UserSignupForm.new(name: name, email: email)
form.valid?
form.errors[:password] # => ["is too short (minimum is 8 characters)"]
```

#### Uniqueness Validations

If you're using Soulless in Rails it's even possible to validate uniqueness.

```ruby
class UserSignupForm

  ...
  
  validates :primary_email, presence: true,
                            uniqueness: { model: User, attribute: :email }
  
  ...
  
end
```

Just let the validator know what ActiveRecord model to use when performing the validation using the ```model``` option.

If your Soulless object attribute doesn't match up to the ActiveRecord model attribute just map it using the ```attribute``` option.

### ```has_one``` and ```has_many``` Associations

When you need associations use ```has_one``` and ```has_many```. Look familiar?

```ruby
class Person
  include Soulless.model
  
  attribute :name, String
  
  validates :name, presence: true
  
  has_one :spouse do
    attribute :name, String
  end
  
  has_many :friends do
    attribute :name, String
  end
end
```

You can set ```has_one``` and ```has_many``` attributes by setting their values hashes and hash arrays.

```ruby
person = Person.new(name: 'Anthony')
person.spouse = { name: 'Megan' }
person.friends = [{ name: 'Yaw' }, { name: 'Biff' }]
```

It's also possible for an association to inherit from a parent class and then extend functionality.

```ruby
class Person
  include Soulless.model
  
  attribute :name, String
  
  validates :name, presence: true
  
  has_one :spouse, Person do # inherits 'name' and validation from Person
    attribute :anniversary, DateTime
    
    validates :anniversary, presence: true
  end
  
  has_many :friends, Person # just inherit from Person, don't extend
end
```

When you need to make sure an association is valid before processing the object use ```validates_associated```.

```ruby
class Person

  ...
  
  has_one :spouse do
    attribute :name, String
    
    validates :name, presence: true
  end
  
  ...
  
end

person = Person.new(name: 'Anthony')
person.spouse = { name: nil }
person.valid? # => false
person.errors[:spouse] # => ["is invalid"]
person.spouse.errors[:name] # => ["can't be blank"]
```

### I18n

Define locales similar to how you would define them in Rails.


```yaml
en:
  soulless:
    errors:
      models:
        person:
          name:
            blank: "there's nothing here"
```

For attributes defined as ```has_one``` and ```has_many``` associations use the enclosing class as the locale key's namespace.

```yaml
en:
  soulless:
    errors:
      models:
        person/spouse:
          name:
            blank: "there's nothing here"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits
[![Sticksnleaves](http://sticksnleaves-wordpress.herokuapp.com/wp-content/themes/sticksnleaves/images/snl-logo-116x116.png)](http://www.sticksnleaves.com)

Soulless is maintained and funded by [Sticksnleaves](http://www.sticksnleaves.com)

Thanks to all of our [contributors](https://github.com/anthonator/soulless/graphs/contributors)