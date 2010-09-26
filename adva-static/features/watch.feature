Feature: Updating the database based on changes to the import source files
  
  Scenario Outline: Editing a blog post source files
    Given an empty import directory "www.example.com"
     And a site with a blog named "<blog>"
     And a post with the following attributes:
      | section    | <blog>   |
      | title      | Title    |
      | body       | Body     |
      | created_at | 2010-1-1 |
     And a source file "<blog_source>" with the following values:
      | name  | <blog>   |
     And a source file "<post_source>" with the following values:
      | title | Title        |
      | body  | Updated body |
    Then the watcher should "PUT" the following "post" params for the file "<post_source>":
      | title      | Title        |
      | body       | Updated body |
      | created_at | 2010-1-1     |
      | site_id    | adva-cms     |
      | section_id | <blog>       |
    Examples:
      | blog | blog_source | post_source           | comment                    |
      | Home |             | 2010-1-1-foo.yml      | an anonymous root blog     |
      | Home | index.yml   | 2010-1-1-foo.yml      | a defined root blog        |
      | Blog |             | blog/2010-1-1-foo.yml | an anonymous non-root blog |
      | Blog | blog.yml    | blog/2010-1-1-foo.yml | a defined non-root blog    |