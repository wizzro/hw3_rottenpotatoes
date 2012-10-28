# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
#flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  page.body.should =~ /#{e1}.*#{e2}/m
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(', ').each do |r|
     if uncheck
        uncheck("ratings_#{r}")
     else
        check("ratings_#{r}")
     end
  end
end

When /I (un)?check all the ratings/ do |uncheck|
   ratings_list = Movie.all_ratings
   ratings_list.each do |rating|
      if uncheck.nil?
         puts "Checking rating: ratings_" + rating
         check("ratings_" + rating)
      else
         puts "Unchecking rating: ratings_" + rating
         uncheck("ratings_" + rating)
      end
   end
end

When /I press '(.*)'/ do |b|
   click_button(b)
end

Then /I should see movies rated 'PG' or 'R'/ do
   page.body.should match(/<td>PG<\/td>/)
   page.body.should match(/<td>R<\/td>/)
   page.has_xpath?('//td', :count => Movie.where(:rating => ['PG', 'R']).length)
#   page.has_xpath?('//td', :text => "/toto/")
#   page.has_xpath?('//td', :text => "/R/")
end

Then /I should not see movies rated 'PG-13' or 'G'/ do
   page.body.should_not match(/<td>PG-13<\/td>/)
   page.body.should_not match(/<td>G<\/td>/)
   page.has_no_xpath?('//td', :count => Movie.where(:rating => ['PG-13', 'G']).length)
#   page.has_no_xpath?('//td', :text => "/PG-13/")
#   page.has_no_xpath?('//td', :text => "/G$/")
end

Then /I should see all of the movies/ do
#Movie.find(:all).length.should page.body.scan(/<tr>/).length
   (page.all("table#movies tr").count - 1).should == Movie.count(:title)
end

Then /I should see none of the movies/ do
#Movie.find(:all).length.should page.body.scan(/<tr>/).length
   (page.all("table#movies tr").count - 1).should == 0
end
