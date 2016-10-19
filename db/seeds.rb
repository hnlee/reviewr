coding_projects = ['HTTP Server', 'Hangman', 'TTT', 'Bowling Game Kata', 'Coin Changer Kata', 'Roman Numerals Kata', 
          'Conways Game of Life Kata', 'Anagrams Kata', 'Prime Factors Kata', 'Mastermind']

languages = ['Java', 'Ruby', 'Clojure', 'Python', 'Haskell', 'Elixir', 'Elm', 'C#', 'Go', 'Rust', 'Javascript']

greetings = ['Hey there! ', 'Well hello there. ', 'Hi. ', 'Youre here! ', 'Greetings. ', 'Welcome. ']

schmooze =  ['I worked really hard on this project', 'I am really excited for you to check out my project', 
            'I appreciate you checking out my work', 'I am super pumped to see what you have to say about it', 
            'You are on my board so I am required to share this with you', 'This is the first iteration',
            'This is the second iteration', 'I have been working on this since the beginning of the month', 
            'I feel like it is missing something, but I cant put my finger on it', 'I am very proud of this', 
            'The fact that you are taking time out of your busy, busy day means so very much to me', 
            'This is the first time I have had the opportunity to work with this technology']

userNames = ['barakobama', 'hillaryclinton', 'donaldtrump', 'berniesanders', 'tedcruz', 'jebbush', 'marcorubio', 'lincolnchafee',
             'martinomalley', 'jimwebb', 'ricksantorum', 'scottwalker', 'chrischristie', 'bencarson']

titles = []

20.times do
  titles << languages.sample + ' ' + coding_projects.sample
end

descriptions = []

20.times do |i|
  description = (greetings.sample + "I want to invite you to check out my " + titles[i] + ". " + schmooze.sample + ". You can check out my repo here: www.github.com/" + userNames.sample + "/" + titles[i].gsub(/\s+/, "-") + ". Thanks in advance for your feedback!")
  descriptions << description
end

projects = titles.zip(descriptions)

projects.each do |title, description|
  Project.create(title: title, description: description)
end