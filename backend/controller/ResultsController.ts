import { DatabaseRepository } from '../model/repositories/DatabaseRepository';

export function ResultsController() {
  return async (req, res) => {
    const repository = new DatabaseRepository();
    let response: any;
    response = await repository.getThumbnails(req.params.start, req.params.end);
    res.send(response);
};
}