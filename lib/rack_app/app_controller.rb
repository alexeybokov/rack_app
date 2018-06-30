module RackApp
  module AppController
    def response
      if @request.post?
        case @request.path
        when '/run'
          run
        end
      else
        case @request.path
        when '/'
          start 'new game' # reset secret code & hint status in server side file_DB
          index
        when "/hint"
          hint
        else
          Rack::Response.new('Not Found', 404)
        end
      end
    end

    def run
      puts @request.params.inspect
      # run game
      Rack::Response.new(
        {
          result: "the value #{@request.params['numbers']} is correct",
          current_round: 123
        }.to_json
      )
    end

    def index
      Rack::Response.new(render("index.html.erb"))
    end

    def hint
      Rack::Response.new(@game.hint.result)
    end

    private

    def game(numbers, current_round)
      Codebreaker::Game.new(numbers, current_round)
    end
  end
end
