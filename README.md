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

Just define a plain-old-ruby-object, inherit from `Soulless::Model` and get crackin'!

```ruby
class UserSignupForm < Soulless::Model
  attribute :name, String
  attribute :email, String
  attribute :password, String

  validates :name, presence: true

  validates :email, presence: true,
                    uniqueness: { model: User }

  validates :password, presence: true,
                       lenght: { is_at_least: 8 }
end
```

### Validations and Errors

Soulless lets you define your validations and manage your errors just like you did in Rails.

```ruby
class UserSignupForm < Soulless::Model

  ...

  validates :name, presence: true

  validates :email, presence: true,
                    uniqueness: { model: User }

  validates :password, presence: true,
                       lenght: { minimum: 8 }

  ...

end
```

Check to see if your object is valid by calling `valid?`.

```ruby
form = UserSignupForm.new(name: name, email: email)
form.valid? # => false
```

See what errors are popping up using the `errors` attribute.

```ruby
form = UserSignupForm.new(name: name, email: email)
form.valid?
form.errors[:password] # => ["is too short (minimum is 8 characters)"]
```

#### Uniqueness Validations

If you're using Soulless in Rails it's even possible to validate uniqueness.

```ruby
class UserSignupForm < Soulless::Model

  ...

  validates :primary_email, presence: true,
                            uniqueness: { model: User, attribute: :email }

  ...

end
```

Just let the validator know what ActiveRecord model to use when performing the validation using the `model` option.

If your Soulless object attribute doesn't match up to the ActiveRecord model attribute just map it using the `attribute` option.

### Callbacks

Soulless supports the validation callback. You can use this callback as you
would on a Rails model.

```ruby
class Person < Soulless::Model

  attribute :name, String

  validates :name, presence: true

  before_validation :change_name_to_bart_simpson

  private
  def change_name_to_bart_simpson
    self.name = 'Bart Simpson'
  end
end

person = Person.new(name: 'Anthony')
person.valid?
person.name # => "Bart Simpson"
```

### Dirty Attributes

Dirty attribute allow you to track changes to a Soulless object before it's saved.

```ruby
person = Person.name(name: "Anthony", spouse: { name: "Mary Jane Watson" })
person.name = 'Peter Parker'
person.changed? # => true
person.changed # => ["name"]
person.changes # => { name: ["Anthony", "Peter Parker"] }
person.name_changed? # => true
person.name_was # => "Anthony"
person.name_change # => ["Anthony", "Peter Parker"]
```

### Inheritance

One of the biggest pitfalls of the form object pattern is duplication of code. It's not uncommon for a form object to define attributes and validations that are identical to the model it represets.

To get rid of this annoying issue Soulless implements the `#inherit_from(klass, options = {})` method. This method will allow a Soulless model to inherit attributes and validations from any Rails model, Soulless model or Virtus object.

```ruby
class User < ActiveRecord::Base
  validates :name, presence: true

  validates :email, presence: true,
                    uniqueness: { case_insensitive: true }
end
```

```ruby
class UserSignupForm < Soulless::Model
  inherit_from(User)
end
```

The `UserSignupForm` has automatically been defined with the `name` and `email` attributes and validations.

```ruby
UserSignupForm.attributes # => name and email attributes
form = UserSignupForm.new
form.valid? # => false
form.errors.messages # => { name: ["can't be blank"], email: ["can't be blank"] }
```

If your model is using the uniqueness validator it will automatically convert it to the [uniqueness validator provided by Soulless](https://github.com/anthonator/soulless#uniqueness-validations).

The `#inherit_from(klass, options = {})` method also allows you to provide options for managing inherited attributes.

If you don't want to inherit the `email` attribute define it using the `exclude` option.

```ruby
class UserSignupForm < Soulless::Model
  inherit_from(User, exclude: :email)
end

UserSignupForm.attributes # => email will not be inherited
form = UserSignupForm.new
form.valid? # => false
form.errors.messages # => { name: ["can't be blank"] }
```

You can also flip it around if you only want the `name` attribute by using the `only` option.

```ruby
class UserSignupForm < Soulless::Model
  inherit_from(User, only: :name)
end

UserSignupForm.attributes # => email will not be inherited
form = UserSignupForm.new
form.valid? # => false
form.errors.messages # => { name: ["can't be blank"] }
```

#### Available Options

`only` - Only inherit the attributes and validations for the provided attributes. Any attributes not specified will be ignored. Accepts strings, symbols and an array of strings or symbols.

`exclude` - Don't inherit the attributes and validations for the provided attributes. Accepts strings, symbols and an array of strings or symbols.

`skip_validators` - Only inherit attributes. Don't inherit any validators. Accepts a boolean.

`use_database_default` - Use the value of the `default` migration option as the default value for an attribute. Accepts either a boolean (for all attributes), a string or symbol for a single attribute or an array of strings and symbols for multiple attributes.

`additional_attributes` - Used to specify attributes that cannot automatically be added to the form model. These are generally attributes that have been specified using `attr_accessor`. Accepts a string, symbol or an array of strings and symbols for multiple attributes.

`validate_attribute_on` - By default any validation that specifies an `:on` option will not be inherited. This option will allow you to inherit a validator that uses the `:on` with a specific value. Example usage: `validate_password_on: :create`. Accepts a string or symbol. This option will accept any value that the Rails `:on` validator option can accept.

### Serialization

Soulless automatically handles serializing and deserializing Soulless models
using the standard ActiveRecord serialization methods.

```ruby
class Profile < Soulless::Model
  attribute :first_name, String
  attribute :last_name, String

  ...
end

class User < ActiveRecord::Base
  serialize :profile, Profile

  ...
end

user = User.new
user.profile = { first_name: 'Anthony', last_name: 'Smith' }
user.profile # => Profile(first_name: 'Anthony', last_name: 'Smith')
```

If you want to implement your own serialization/deserialization process just
implement your own `self.load(value)` and `self.dump(value)` methods on your
model.

### I18n

Define locales similar to how you would define them in Rails.


```yaml
en:
  soulless:
    errors:
      models:
        person:
          attributes:
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
