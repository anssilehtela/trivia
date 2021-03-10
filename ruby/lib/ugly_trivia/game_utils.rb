class GameUtils
  QUESTION_CATEGORIES = ["Pop", "Science", "Sports", "Rock"].freeze
  QUESTION_AMOUNT = 50

  def self.generate_questions
    questions = {}
    QUESTION_CATEGORIES.each do |cat|
      questions[cat.to_sym] = []
    end

    QUESTION_AMOUNT.times do |i|
      QUESTION_CATEGORIES.each do |cat|
        questions[cat.to_sym] << "#{cat} Question #{i}"
      end
    end
    questions
  end

  def self.question_category(place)
    QUESTION_CATEGORIES[place % QUESTION_CATEGORIES.size].to_sym
  end

end