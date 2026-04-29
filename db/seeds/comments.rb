puts "Seeding Comments..."
return if Comment.count.positive? || Article.count.zero?

article1 = Article.find_by(title: "Getting Started with Rails")
article2 = Article.find_by(title: "Understanding MVC Architecture")
article3 = Article.find_by(title: "Active Record Basics")

comments = []
comments << { article: article1, author: "Emily", body: "Great introduction! This helped me understand the basics of Rails." } if article1
comments << { article: article1, author: "Raj", body: "I like how the conventions make building apps faster." } if article1
comments << { article: article2, author: "Aisha", body: "The MVC explanation is clear and easy to follow." } if article2
comments << { article: article3, author: "Miguel", body: "Active Record is much easier now that I see the practical examples." } if article3

Comment.create!(comments) if comments.any?
puts "Seeding Comments... Done."
