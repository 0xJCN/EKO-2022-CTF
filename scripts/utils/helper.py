from ape import chain, project
import subprocess

w3 = chain.provider.web3


def get_challenge_instance(
    eko,
    challenge,
    user,
    value="0 wei",
    tx=False,
):
    print("\n--- Creating challenge instance ---\n")
    eko = project.ChallengeManager.at(eko)
    create_tx = eko.deployChallenge(
        challenge,
        sender=user,
        value=value,
    )
    instance = [
        w3.toChecksumAddress(log.challengeContracts[0])
        for log in eko.Deployed.from_receipt(create_tx)
    ][0]
    print(f"\n--- Challenge Instance: {instance} ---\n")
    if tx:
        return instance, eko, create_tx
    return instance, eko


def challenge_broken(eko, receipt, user, factory):
    assert len(receipt.logs) != 0, "\n--- !Challenge not broken! ---\n"
    logs = [log for log in eko.ChallengeBreak.from_receipt(receipt)][0]
    assert (
        logs.user == user and logs.challenge == factory
    ), "\n--- !something went wrong! ---\n"


def prep_blueprint_deployment(contract_name):
    bytecode = subprocess.run(
        ["vyper", "-f", "blueprint_bytecode", "./contracts/" + contract_name + ".vy"],
        text=True,
        capture_output=True,
    ).stdout[:-1]
    blueprint_address = send_tx("", bytecode).contractAddress
    deployment_code = (
        chain.project_manager.get_contract(contract_name)
        .contract_type.get_deployment_bytecode()
        .hex()
    )
    return blueprint_address, deployment_code


def send_tx(recipient, calldata):
    w3.eth.default_account = w3.eth.accounts[0]
    tx = w3.eth.send_transaction(dict(to=recipient, data=calldata))
    return w3.eth.wait_for_transaction_receipt(tx)
