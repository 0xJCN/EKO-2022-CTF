from ape import accounts, project
from .utils.helper import get_challenge_instance, challenge_broken

CHALLENGE_MANAGER = "0x157EB6396D44F63D3970a72C253BfB5ACEEc80dD"
CHALLENGE_FACTORY = "0x4d3496edEbD090b53a0F8e3FA77B9BfC5fF9e927"


def main():
    # setting up user
    user = accounts.test_accounts[0]

    # get challenge instance
    instance, eko = get_challenge_instance(
        CHALLENGE_MANAGER,
        CHALLENGE_FACTORY,
        user,
    )
    # deploy hacker contract
    print("\n--- Deploying hacker contract ---\n")
    hacker = project.HiddenKitty.deploy(instance, sender=user)

    # exploit goes here
    print("\n--- Exploiting challenge instance ---\n")
    hacker.attack(sender=user)

    # submiting challenge instance
    print("\n--- Breaking challenge instance ---\n")
    submit_tx = eko.breakChallenge(CHALLENGE_FACTORY, sender=user)

    # checking if challenge is completed
    challenge_broken(eko, submit_tx, user.address, CHALLENGE_FACTORY)

    print("\n--- 🥂!CHALLENGE COMPLETED!🥂 ---\n")


if __name__ == "__main__":
    main()
