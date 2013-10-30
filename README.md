# Soulless

Rails models without the database (and Rails).

Great for implementing the form object pattern. [Check out #3](http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/) of this great article by @brynary for more information on the form object pattern.

## Installation

Add this line to your application's Gemfile:

    gem 'soulless'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install soulless

## Usage

Just define a plain-old-ruby-object and get crackin'!

```ruby
class UserSignupForm
  include Soulless.model
  
  attribute :email, String
  attribute :name, String
  attribute :password
  attribute :super_awesome, Boolean, default: false
  
  validates :email, presence: true
  
  validates :name, presence: true
  
  validates :password, presence: true,
                       lenght: { is_at_least: 8 }

  private
  def persist!
    # You're gonna need this!
	# Define what to do with this form when ready to save here.
  end
end
```

Awesome. Now let's do something with it.

```ruby
UsersController < ApplicationController
  def create
	@form = UserSignupForm.new(params.permit(user: [:email, :name, :password, :super_awesome]))
	if @form.save
	  # do something here
	else
	  render :new
	end
  end
end
```

### Configuration

```ruby
class UserSignupForm
  # include attribute DSL + constructor + mass-assignment
  include Soulless.model
end
```

```ruby
class UserSignupForm
  # include attribute DSL + constructor
  include Soulless.model(mass_assignment: false)
end
```

```ruby
class UserSignupForm
  # include attribute DSL
  include Soulless.model(constructor: false, mass_assignment: false)
end
```

### Rails not required!

The great thing about Soulless? Batteries are included. Rails not required.

### This looks familir...

You noticed? We're using Virtus to power this gem. That means you get all the Virtus goodies for free. Check out [their GitHub page](https://github.com/solnic/virtus) to see what's up.

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