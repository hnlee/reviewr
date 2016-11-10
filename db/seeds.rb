coding_projects = ['HTTP Server', 'Hangman', 'TTT', 'Bowling Game', 'Coin Changer', 'Roman Numerals', 
          'Conway\'s Game of Life', 'Anagrams', 'Prime Factors', 'Mastermind']

languages = ['Java', 'Ruby', 'Clojure', 'Python', 'Haskell', 'Elixir', 'Elm', 'C#', 'Go', 'Rust', 'Javascript']

greetings = ['Hey there! ', 'Well hello there. ', 'Hi. ', 'You\'re here! ', 'Greetings. ', 'Welcome. ']

schmooze =  ['I worked really hard on this project', 
            'I am really excited for you to check out my project', 
            'I appreciate you checking out my work', 
            'I am super pumped to see what you have to say about it', 
            'You are on my board so I am required to share this with you', 
            'This is the first iteration',
            'This is the second iteration', 
            'I have been working on this since the beginning of the month', 
            'I feel like it is missing something, but I cant put my finger on it', 
            'I am very proud of this', 
            'The fact that you are taking time out of your busy, busy day means so very much to me', 
            'This is the first time I have had the opportunity to work with this technology']

user_names = ['barackobama', 'hillaryclinton', 'donaldtrump', 'berniesanders', 'tedcruz', 'jebbush', 'marcorubio', 'lincolnchafee',
             'martinomalley', 'jimwebb', 'ricksantorum', 'scottwalker', 'chrischristie', 'bencarson']

review_content = ['This looks great', 
                  'This looks awful', 
                  'This looks really good', 
                  'This needs work',
                  'One thing I really liked was how you were able to capture the mood of the reader', 
                  'One thing I did not think was great was the way that your indentations are inconsistent',
                  'This shows a lot of potential', 
                  'This shows no potential', 
                  'This is not at all what I was expecting', 
                  'While it certainly clever, it is not obvious what you are trying to do, not very readable',
                  'I dont really understand the premise here. Maybe you should try to explain this out loud to someone and see if it makes sense.',
                  'Hey this looks great! I dont even know what to tell you to fix, it is perfect, just like you!',
                  'Did you plagiarize this? This looks oddly familiar...', 
                  'Reading this is giving me a headache', 
                  'This is really good, I can tell that you have made a lot of changes from the previous iteration and it shows. You addressed the spacing issue, but I am not sure that my feedback about the font was taken correctly. Maybe we can do an in person meeting and I can explain what I meant.', 
                  'Wow!', 
                  'You should move line 43 to a separate file, it is creating a clear violation of the Single Responsibility Principle', 
                  'By including line 112, you are creating a violation of the Dependency Inversion Principle', 
                  'I am really impressed by your use of the Open-Closed Principle',
                  'Great use of the Liskov Substitution Principle here', 
                  'The way that this is written, it violates the Interface Segregation Principle. I would fix this if I were you.',
                  'This looks really great. It is obvious that you are really considering your SOLID principles here']

thumbs_up = [ '',
              'This is a good review',
              'This is a great review']

thumbs_down = [ 'This is not kind',
                'This is not specific',
                'This is not actionable',
                'This is neither kind nor specific',
                'This is neither specific nor actionable',
                'This is neither kind nor actionable',
                'This is neither kind, specific, or actionable' ]

project_count = 20

user_names.each do |name|
  User.create(name: name, email: name + '@gmail.com', uid: 'uid' + name)
end

User.create(name: 'Nicole Carpenter', email: 'ncarpenter@8thlight.com', uid: '101379786221150376018')
User.create(name: 'Hana Lee', email: 'hana@8thlight.com', uid: '106812979936097644716')

project_count.times do |i|
  title = languages.sample + ' ' + coding_projects.sample
  description = (greetings.sample + 'I want to invite you to check out my ' + title + '. ' + schmooze.sample + '. You can check out my repo here: www.github.com/' + user_names.sample + '/' + title.gsub(/\s+/, '-') + '. Thanks in advance for your feedback!')
  Project.create(title: title, description: description)
end

project_count.times do |index|
  ProjectOwner.create(project_id: index + 1, user_id: rand(User.count) + 1)
end

100.times do
  ProjectInvite.create(project_id: rand(Project.count) + 1, user_id: rand(User.count) + 1)
end

review_content.each do |content|
  Review.create(content: content)
end

75.times do
  ProjectReview.create(project_id: rand(Project.count) + 1, review_id: rand(Review.count) + 1)
end

45.times do
  UserReview.create(user_id: rand(User.count) + 1, review_id: rand(Review.count) + 1)
end

20.times do
  rand_bool = rand(2)
  if rand_bool == 1
    Rating.create(helpful: true, explanation: thumbs_up.sample)
  else
    Rating.create(helpful: false, explanation: thumbs_down.sample) 
  end
end

75.times do
  ReviewRating.create(review_id: rand(Review.count) + 1, rating_id: rand(Rating.count) + 1)
end

75.times do
  UserRating.create(user_id: rand(User.count) + 1, rating_id: rand(Rating.count) + 1)
end
