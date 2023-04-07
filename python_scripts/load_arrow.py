import sys
import sfi
from pyarrow import feather


def main(filename):
    arrow_table = feather.read_table(filename)
    sfi.Data.setObsTotal(arrow_table.num_rows)


if __name__ == "__main__":
    filename = sys.argv[1]
    main(filename)
