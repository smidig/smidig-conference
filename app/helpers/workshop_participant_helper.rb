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
end
