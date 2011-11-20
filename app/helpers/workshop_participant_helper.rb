# -*- encoding : utf-8 -*-
module WorkshopParticipantHelper
  def workshop_participation_link(talk, user)
    if talk.participant?(user)
      wsp = talk.workshop_participants.where(:user_id => user.id).first
      button_to 'Annullere påmelding', talk_workshop_participant_path(talk, wsp),
              :confirm => "Sure?", :method => :delete, :class => 'leave-workshop'
    elsif talk.complete?
      """
      <span class='workshop-full'>Ingen plasser igjen</span>
      """.html_safe
    else
      button_to 'Meld deg på', talk_workshop_participant_index_path(talk),
              :method => :post, :class => 'join-workshop'
    end
  end

  def workshop_stats(talk)
    n = talk.participants.count
    link_to_if n > 0, "Påmeld: #{n}/#{talk.max_participants}", talk_workshop_participant_index_path(talk)
  end

  def conditional_link_to_participant_list(talk)
    n = talk.participants.count
    if (n == 0)
      "Ingen deltagere har registrert seg ennå."
    else
      link_to pluralize(n, 'deltaker', 'deltakere'),
            talk_workshop_participant_index_path(talk)
    end
  end
end
