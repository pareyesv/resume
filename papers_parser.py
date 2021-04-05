from typing import Iterator


class DataIndices():
    papers: int
    journals: int

    def __init__(self, data):
        self.papers, self.journals = DataIndices._get_indices_papers_journals(data)

    @staticmethod
    def _get_indices_papers_journals(data):
        for idx, elem in enumerate(data["sections"]):
            if elem["title"] == "Papers":
                idx_papers = idx
                break
        for idx, elem in enumerate(data["sections"][idx_papers]["entries"]):
            if elem["title"] == "Refereed Publications":
                idx_journals = idx
                break
        return idx_papers, idx_journals


def parse_journals(papers_references: dict) -> Iterator[dict]:
    """Parse Journals info from Zotero Better CSL YAML.

    Args:
        papers_references (dict): Info from publications from Zotero export.

    Returns:
        Iterator(dict): paper info parsed
    """
    for paper in papers_references:
        if paper["type"] != "article-journal":
            continue
        authors = [f"""{author["given"]} {author["family"]}"""
                   for author in paper.get("author")]
        relevant_info = {"year": paper["issued"][0]["year"] or "",
                         "title": paper.get("title", ""),
                         "journal": (paper.get("container-title-short") or
                                     paper.get("container-title") or
                                     paper.get("source")
                                     ),
                         "authors": authors
                         }
        if "DOI" in paper:
            relevant_info["doi"] = paper["DOI"]
        if "URL" in paper:
            relevant_info["url"] = dict(link=paper["URL"], name=paper["URL"])

        yield relevant_info


def get_updated_journals(data: dict, papers: dict):
    indices = DataIndices(data)
    data["sections"][indices.papers]["entries"][indices.journals]["entries"] = (
        data["sections"][indices.papers]["entries"][indices.journals]["entries"] +
        list(parse_journals(papers["references"]))
        )
    return data
