# -*- encoding : utf-8 -*-
module WorkshopParticipantHelper
  def workshop_participation_link(talk, user)
    if talk.participant?(user)
      """
      <span class='leave-workshop'>Leave</span>
      """.html_safe
    elsif talk.complete?
      """
      <span class='workshop-full'>Sorry, full</span>
      """.html_safe
    else
      """
      <span class='join-workshop'>Sign up!</span>
      """.html_safe
    end
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
