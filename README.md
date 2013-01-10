# ActiveModel::Policy

The purpose of *ActiveModel::Policy* is to encapsulate the logic of checking whether an action can be performed on the given object by an actor. By abtracting the this concern into objects permission can be broken into more meaningful and managable parts.

## Installation

Add this line to your application's Gemfile:

    gem 'active_model_policy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_model_policy

## Creating a Policy

To create a policy object simply use the Rails generator:

    $ rails generate policy *my_model_name*

The file will be created in `app/policies/*my_model_name.rb*`.

To manually create a policy object simply create any standard object subclassing `ActiveModel::Policy`. You should end up with something like this:

```ruby
class MyModelNamePolicy < ActiveModel::Policy
end
```

A policy is nothing more than a series of methods which return true or false based on the state of the model, and optionally scoped. To declare a check, or in policy terms "forming a question", you simply do:

```ruby
class PostPolicy < ActiveModel::Policy
  can :read do |context|
    model.active?
  end
end
```

The `can` helper underneath simply defines the method `can_read?`. The method returns a truthy or falsy as to whether the action can be performed or not. The idea is that you are asking a question whether the action **can** be performed as the given **context**. The context is not mandatory but it is generally good to use one, even if it is `nil`.

`can` accepts multiple names, so the same check can be used for multiple actions.

## Using the Policy

To use a policy you instantiate it as any Ruby object and pass it the model for which it is to perform checks on. ie. `PostPolicy.new post`.

```ruby
policy = PostPolicy.new post
policy.can? :read
```

As a helper to ActiveRecord models, you can simply call `to_policy` which will look for the correct policy based on name and pass itself to the policy.

```ruby
policy = post.to_policy
policy.can? :read
```

You can add this behaviour to your own objects by adding `include ActiveModel::PolicySupport` to your class.

## Policy context

A context can be anything or nothing, and are very useful to add perspective to your policy. A policy defines rules, or permissions, on what actions can be performed but this might need more context such as who or what. A context is simply passing an argument to the question which responds based on the context. In short, it adds more dimention to checking the permission.

To make working with context easier, an object can be marked as a context by including the model. ie. `include ActiveModel::PolicyContext`. Then questions can be asked on the context directly:

```ruby
user.can? :read, post
```

Controllers and views have the context set by default to `current_user`, so you can use `can?` instead.

## Customising context

The context is given to each question asked on the policy to determine whether to grant permission. By default, this is set to `current_user` on the controller but can be changed:

```ruby
class ApplicationController < ActionController::Base
  policy_context :current_user
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
