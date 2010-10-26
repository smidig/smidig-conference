class Statistics::UsersByCompanyController < ApplicationController

  before_filter :require_admin

  def index
    if params[:filter]
      case params[:filter]
        when 'speakers'
          @title = 'Antall deltakere med innsendt foredrag pr selskap'
          @companies = User.find_by_sql("SELECT company, count(*) num_of_participants FROM (SELECT DISTINCT u.name, u.company FROM users u INNER JOIN speakers s ON u.id = s.user_id INNER JOIN talks t ON t.id = s.talk_id ORDER BY u.company, u.name) GROUP BY company ORDER BY num_of_participants DESC, company")
        when 'accepted'
          @title = 'Antall deltakere med godkjent foredrag pr selskap'
          @companies = User.find_by_sql("SELECT company, count(*) num_of_participants FROM (SELECT DISTINCT u.name, u.company FROM users u INNER JOIN speakers s ON u.id = s.user_id INNER JOIN talks t ON t.id = s.talk_id WHERE t.acceptance_status = 'accepted' ORDER BY u.company, u.name) GROUP BY company ORDER BY num_of_participants DESC, company")
        else
          flash[:error] = "Ukjent filter"
          @title = ""
          @companies = []
      end
    else
      @title = 'Antall deltakere pr selskap'
      @companies = User.find_by_sql("SELECT company, count(*) num_of_participants FROM users GROUP BY company ORDER BY num_of_participants DESC, company")
    end
  end

end
