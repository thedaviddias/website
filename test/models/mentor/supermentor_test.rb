require "test_helper"

class Mentor::SupermentorTest < ActiveSupport::TestCase
  test "eligible?" do
    track = create :track, :random_slug
    user = create :user

    # Sanity check: no mentor
    refute Mentor::Supermentor.eligible?(user)

    # Sanity check: mentor but not mentored anything
    mentorship = create :user_track_mentorship, user: user, track: track
    user.update(roles: [:mentor])
    refute Mentor::Supermentor.eligible?(user)

    # Sanity check: ignore other user's track mentorships
    other_user = create :user
    create :user_track_mentorship, num_finished_discussions: 150, user: other_user, track: track
    refute Mentor::Supermentor.eligible?(user)

    # Sanity check: mentored too few students
    mentorship.update(num_finished_discussions: 80)
    refute Mentor::Supermentor.eligible?(user)

    # Sanity check: satisfactiong rating too low
    mentorship.update(num_finished_discussions: 105)
    user.update(mentor_satisfaction_percentage: 80)
    refute Mentor::Supermentor.eligible?(user)

    # Requirements met
    user.update(mentor_satisfaction_percentage: 96)
    assert Mentor::Supermentor.eligible?(user)
  end

  test "for_track?" do
    track = create :track, :random_slug
    other_track = create :track, :random_slug
    mentor = create :user
    other_mentor = create :user
    mentorship = create :user_track_mentorship, user: mentor, track: track

    # Sanity check: not mentored anything
    refute Mentor::Supermentor.for_track?(mentor, track)

    # Sanity check: ignore other user's track mentorships
    create :user_track_mentorship, num_finished_discussions: 150, user: other_mentor, track: track
    refute Mentor::Supermentor.for_track?(mentor, track)

    # Sanity check: ignore other track's mentorships
    create :user_track_mentorship, num_finished_discussions: 177, user: mentor, track: other_track
    refute Mentor::Supermentor.for_track?(mentor, track)

    # Sanity check: mentored too few students
    mentorship.update(num_finished_discussions: 80)
    refute Mentor::Supermentor.for_track?(mentor, track)

    # Sanity check: satisfactiong rating too low
    mentorship.update(num_finished_discussions: 105)
    mentor.update(mentor_satisfaction_percentage: 80)
    refute Mentor::Supermentor.for_track?(mentor, track)

    # Requirements met
    mentor.update(mentor_satisfaction_percentage: 96)
    assert Mentor::Supermentor.for_track?(mentor, track)
  end

  %i[admin staff].each do |role|
    test "for_track? enabled for #{role}" do
      track = create :track
      user = create :user, role

      assert Mentor::Supermentor.for_track?(user, track)
    end
  end
end
