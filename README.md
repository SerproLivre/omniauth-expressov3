# OmniAuth Twitter

[![Gem Version](https://badge.fury.io/rb/omniauth-twitter.svg)](http://badge.fury.io/rb/omniauth-twitter)
[![Circle CI](https://circleci.com/gh/abner/omniauth-expressov3/tree/master.svg?style=svg)](https://circleci.com/gh/abner/omniauth-expressov3/tree/master)
[![Code Climate](https://codeclimate.com/github/abner/omniauth-expressov3.png)](https://codeclimate.com/github/abner/omniauth-expressov3)
[![Code Climate Coverage](https://codeclimate.com/github/abner/omniauth-expressov3/coverage.png)](https://codeclimate.com/github/abner/omniauth-expressov3)

This gem contains the Expresso strategy for OmniAuth.

## Before You Begin

You should have already installed OmniAuth into your app; if not, read the [OmniAuth README](https://github.com/intridea/omniauth) to get started.


## Using This Strategy

First start by adding this gem to your Gemfile:

```ruby
gem 'omniauth-expressov3'
```

If you need to use the latest HEAD version, you can do so with:

```ruby
gem 'omniauth-expressov3', :github => 'abner/omniauth-expressov3'
```

Next, tell OmniAuth about this provider. For a Rails app, your `config/initializers/omniauth.rb` file should look like this:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :expressov3
end
```


## Authentication Hash
An example auth hash available in `request.env['omniauth.auth']`:

```ruby
{
       "provider" => "expressov3",
            "uid" => nil,
           "info" => {
               "account_id" => "111111111",
               "contact_id" => "contact_id",
                 "username" => "11111111111",
                     "name" => "Joao Ninguem",
               "first_name" => "Joao",
                "last_name" => "Ninguem",
                    "email" => "joao.ninguem@serpro.gov.br",
                "telephone" => "(71)1111-1111",
        "organization_unit" => "SUPDE/DESDR/DE5CT",
                 "tine_key" => "tine_key",
                 "json_key" => "json_key"
    },
    "credentials" => {},
          "extra" => {
        "raw_info" => {
                      "keys" => {
                "tine_key" => "tine_key",
                "json_key" => "json_key"
            },
            "currentAccount" => {
                                "accountId" => "111111111",
                         "accountLoginName" => "11111111111",
                         "accountLastLogin" => "2015-02-10 13:42:15",
                     "accountLastLoginfrom" => "161.148.31.232",
                "accountLastPasswordChange" => "2015-01-05 11:48:58",
                            "accountStatus" => "enabled",
                           "accountExpires" => nil,
                      "accountPrimaryGroup" => "888",
                     "accountHomeDirectory" => "/home/11111111111",
                        "accountLoginShell" => "/bin/bash",
                       "accountDisplayName" => "Joao Ninguem",
                          "accountFullName" => "Joao Ninguem",
                         "accountFirstName" => "Joao",
                          "accountLastName" => "Ninguem",
                      "accountEmailAddress" => "joao.ninguem@serpro.gov.br",
                         "lastLoginFailure" => "2014-06-13 11:59:25",
                            "loginFailures" => 0,
                               "contact_id" => "contact_id",
                                   "openid" => nil,
                               "visibility" => "displayed",
                             "container_id" => 1,
                                 "imapUser" => {
                      "emailMailQuota" => 500,
                       "emailMailSize" => 435,
                         "emailUserId" => "11111111111",
                    "emailForwardOnly" => 0,
                       "emailUsername" => "11111111111"
                },
                                "emailUser" => {
                       "emailForwards" => [],
                    "emailForwardOnly" => false,
                        "emailAliases" => [
                        [0] "joao.ninguem@mail.serpro.gov.br"
                    ],
                        "emailAddress" => "joao.ninguem@serpro.gov.br"
                },
                   "accountPasswordExpired" => "no",
                                "accountDN" => "ou=reg,ou=regsdr,dc=serpro,dc=gov,dc=br",
                                 "smtpUser" => {
                       "emailForwards" => [],
                    "emailForwardOnly" => false,
                        "emailAliases" => [
                        [0] "joao.ninguem@mail.serpro.gov.br"
                    ],
                        "emailAddress" => "joao.ninguem@serpro.gov.br"
                }
            },
               "userContact" => {
                                 "id" => "contact_id",
                "adr_one_countryname" => "",
                   "adr_one_locality" => nil,
                 "adr_one_postalcode" => nil,
                     "adr_one_region" => nil,
                     "adr_one_street" => nil,
                    "adr_one_street2" => nil,
                        "adr_one_lon" => nil,
                        "adr_one_lat" => nil,
                "adr_two_countryname" => "",
                   "adr_two_locality" => nil,
                 "adr_two_postalcode" => nil,
                     "adr_two_region" => nil,
                     "adr_two_street" => nil,
                    "adr_two_street2" => nil,
                        "adr_two_lon" => nil,
                        "adr_two_lat" => nil,
                          "assistent" => nil,
                               "bday" => nil,
                       "calendar_uri" => nil,
                              "email" => "joao.ninguem@serpro.gov.br",
                         "email_home" => "",
                       "freebusy_uri" => nil,
                                "geo" => nil,
                               "note" => nil,
                       "container_id" => 1,
                             "pubkey" => nil,
                               "role" => nil,
                               "room" => nil,
                         "salutation" => nil,
                              "title" => nil,
                                 "tz" => nil,
                                "url" => "",
                           "url_home" => "",
                               "n_fn" => "Joao Ninguem",
                           "n_fileas" => "Joao Ninguem",
                           "n_family" => "Ninguem",
                            "n_given" => "Joao",
                           "n_middle" => nil,
                           "n_prefix" => nil,
                           "n_suffix" => nil,
                           "org_name" => nil,
                           "org_unit" => "SUPDE/DESDR/DE5CT",
                      "tel_assistent" => nil,
                            "tel_car" => nil,
                           "tel_cell" => "(71)1111-1111",
                   "tel_cell_private" => nil,
                            "tel_fax" => nil,
                       "tel_fax_home" => nil,
                           "tel_home" => nil,
                          "tel_other" => nil,
                          "tel_pager" => nil,
                         "tel_prefer" => nil,
                           "tel_work" => "(71)1111-1111",
                         "created_by" => nil,
                      "creation_time" => "2013-07-16 21:36:04",
                   "last_modified_by" => nil,
                 "last_modified_time" => nil,
                         "is_deleted" => "0",
                         "deleted_by" => nil,
                       "deleted_time" => nil,
                                "seq" => 0,
                               "type" => "user",
                          "jpegphoto" => 1,
                         "account_id" => "111111111"
            }
        }
    }
}

```

## Supported Rubies

OmniAuth ExpressoV3 is tested under 1.9.3, 2.0.0, 2.1.0, JRuby, and Rubinius.

## Contributing

Please read the [contribution guidelines](CONTRIBUTING.md) for some information on how to get started. No contribution is too small.

## License

Copyright (c) 2015 by Ábner Oliveira

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
