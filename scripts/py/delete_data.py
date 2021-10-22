import argparse
import os
import sys
from typing import Collection, Sequence

import pandas as pd

from exabel_data_sdk import ExabelClient
from exabel_data_sdk.scripts.base_script import BaseScript
from exabel_data_sdk.util.resource_name_normalization import normalize_resource_name


class DeleteData(BaseScript):
    """
    Deletes the sample data from the Exabel platform using the Data API.
    """

    def __init__(self, argv: Sequence[str], description: str):
        super().__init__(argv, description)
        namespace = os.getenv("EXABEL_NAMESPACE")
        help_text = "The customer's namespace into which to load the resources."
        if namespace:
            help_text += f" Defaults to '{namespace}' (from EXABEL_NAMESPACE environment variable)"
        else:
            help_text += (
                " Can also be specified in the EXABEL_NAMESPACE environment variable."
            )
        self.parser.add_argument(
            "--namespace",
            required=not namespace,
            type=str,
            default=namespace,
            help=help_text,
        )

    def delete_entities(
        self,
        client: ExabelClient,
        namespace: str,
        entity_type: str,
        entities: Collection[str],
    ):
        for entity in entities:
            name = f"entityTypes/{entity_type}/entities/{namespace}.{normalize_resource_name(entity)}"
            try:
                print(f"Deleting entity: {name}")
                client.entity_api.delete_entity(name)
            except:
                print(f"Failed to delete entity: {name}")

    def delete_signals(
        self, client: ExabelClient, namespace: str, signals: Collection[str]
    ):
        for signal in signals:
            name = f"signals/{namespace}.{signal}"
            try:
                print(f"Deleting signal: {name}")
                client.signal_api.delete_signal(name)
            except:
                print(f"Failed to delete signal: {name}")

    def run_script(self, client: ExabelClient, args: argparse.Namespace) -> None:
        brands: pd.DataFrame = pd.read_csv(
            "./resources/data/entities/brands.csv"
        )
        signals: pd.DataFrame = pd.read_csv(
            "./resources/data/time_series/brand_time_series.csv", nrows=0
        ).columns[2:]
        self.delete_signals(
            client=client,
            namespace=args.namespace,
            signals=signals,
        )

        self.delete_entities(
            client=client,
            namespace=args.namespace,
            entity_type="brand",
            entities=brands.brand.values,
        )


if __name__ == "__main__":
    DeleteData(sys.argv, "Deleting sample data.").run()
