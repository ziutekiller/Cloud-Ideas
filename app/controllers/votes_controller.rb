class VotesController < ApplicationController

  def new
    user_quotes = Quote.all.where(user_id: current_user.id)
    return redirect_to root_path if user_quotes.count < 2
    return redirect_to root_path if (cookies[:clicks].to_i + 1) > 10

    quote_1 = user_quotes.order('RANDOM()').first
    quote_2 = user_quotes.where.not(id: quote_1.id).order('RANDOM()').first
    @clicks = cookies[:clicks] || 0
    @vote_form_left = VoteForm.new(preferred_quote_id: quote_1.id, other_quote_id: quote_2.id)
    @vote_form_right = VoteForm.new(preferred_quote_id: quote_2.id, other_quote_id: quote_1.id)
  end

  def create
    count_visits
    VoteForm.new(params[:vote]).save
    redirect_to new_vote_path
  end

  def count_visits
    value = (cookies[:clicks] || 0 ).to_i
    cookies[:clicks] = {:value => value + 1, :expires => Time.now + 10.second}
  end
end

